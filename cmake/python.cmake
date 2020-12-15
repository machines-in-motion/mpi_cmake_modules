# Copyright (C) 2008-2020 LAAS-CNRS, JRL AIST-CNRS, INRIA.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

# .rst: .. cmake:command:: FINDPYTHON
#
# Find python interpreter and python libs. Arguments are passed to the
# find_package command so refer to `find_package` documentation to learn about
# valid arguments.
#
# To specify a specific Python version from the command line, use the command
# ``FINDPYTHON()`` and pass the following arguments to CMake
# ``-DPYTHON_EXECUTABLE=/usr/bin/python3.5 -DPYTHON_LIBRARY=
# /usr/lib/x86_64-linux-gnu/libpython3.5m.so.1``
#
# To specify a specific Python version within the CMakeLists.txt, use the
# command ``FINDPYTHON(2.7 EXACT REQUIRED)``.
#
# If PYTHON_PACKAGES_DIR is set, then the {dist,site}-packages will be replaced
# by the value contained in PYTHON_PACKAGES_DIR.
#
# .. cmake:warning:: According to the ``FindPythonLibs`` and
# ``FindPythonInterp`` documentation, you could also set
# ``Python_ADDITIONAL_VERSIONS``. If you do this, you will not have an error if
# you found two different versions or another version that the requested one.
#

# .rst: .. cmake:variable:: PYTHON_SITELIB
#
# Relative path where Python files will be installed.

# .rst: .. cmake:variable:: PYTHON_EXT_SUFFIX
#
# Portable suffix of C++ Python modules.

function(get_python_interpreter output)

  if(NOT CMAKE_VERSION VERSION_LESS "3.12")

    if(DEFINED PYTHON_EXECUTABLE OR DEFINED Python_EXECUTABLE)
      if(NOT DEFINED Python_EXCUTABLE)
        set(Python_EXCUTABLE ${PYTHON_EXECUTABLE})
      else()
        set(PYTHON_EXCUTABLE ${Python_EXECUTABLE})
      endif()
    else()
      # Search for the default python of the system, if exists
      find_program(PYTHON_EXECUTABLE python)
    endif()

  else(NOT CMAKE_VERSION VERSION_LESS "3.12")

    find_package(PythonInterp ${ARGN})
    if(NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)
      message(FATAL_ERROR "Python executable has not been found.")
    endif(NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)

  endif()

  message(STATUS "PythonInterp: ${PYTHON_EXECUTABLE}")
  set(${output}
      ${PYTHON_EXECUTABLE}
      PARENT_SCOPE)

endfunction()

macro(FINDPYTHON)
  if(DEFINED FINDPYTHON_ALREADY_CALLED)
    message(
      AUTHOR_WARNING
        "Macro FINDPYTHON has already been called. Several call to FINDPYTHON may not find the same Python version (for a yet unknown reason)."
    )
  endif()
  set(FINDPYTHON_ALREADY_CALLED TRUE)
  if(NOT CMAKE_VERSION VERSION_LESS "3.12" AND NOT WIN32)

    if(DEFINED PYTHON_EXECUTABLE OR DEFINED Python_EXECUTABLE)
      if(NOT DEFINED Python_EXCUTABLE)
        set(Python_EXCUTABLE ${PYTHON_EXECUTABLE})
      else()
        set(PYTHON_EXCUTABLE ${Python_EXECUTABLE})
      endif()
    else()
      # Search for the default python of the system, if exists
      find_program(PYTHON_EXECUTABLE python)
    endif()

    if(PYTHON_EXECUTABLE)
      execute_process(
        COMMAND ${PYTHON_EXECUTABLE} --version
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        OUTPUT_VARIABLE _PYTHON_VERSION_OUTPUT
        ERROR_VARIABLE _PYTHON_VERSION_OUTPUT
        OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE)

      string(REGEX REPLACE "Python " "" _PYTHON_VERSION
                           ${_PYTHON_VERSION_OUTPUT})
      string(REGEX REPLACE "\\." ";" _PYTHON_VERSION ${_PYTHON_VERSION})
      list(GET _PYTHON_VERSION 0 _PYTHON_VERSION_MAJOR)

      # Hint for finding the right Python version
      set(Python_EXECUTABLE ${PYTHON_EXECUTABLE})
      set(Python${_PYTHON_VERSION_MAJOR}_EXECUTABLE ${PYTHON_EXECUTABLE})

      find_package("Python${_PYTHON_VERSION_MAJOR}" REQUIRED
                   COMPONENTS Interpreter Development)
    else()
      # No hind was provided. We can then check for first Python 2, then Python
      # 3
      find_package(Python2 QUIET COMPONENTS Interpreter Development)
      if(NOT Python2_FOUND)
        find_package(Python3 QUIET COMPONENTS Interpreter Development)
        if(NOT Python3_FOUND)
          message(FATAL_ERROR "Python executable has not been found.")
        else()
          set(_PYTHON_VERSION_MAJOR 3)
        endif(NOT Python3_FOUND)
      else()
        set(_PYTHON_VERSION_MAJOR 2)
      endif(NOT Python2_FOUND)
    endif(PYTHON_EXECUTABLE)

    set(_PYTHON_PREFIX "Python${_PYTHON_VERSION_MAJOR}")

    if(${_PYTHON_PREFIX}_FOUND)
      set(PYTHON_EXECUTABLE ${${_PYTHON_PREFIX}_EXECUTABLE})
      set(PYTHON_LIBRARY ${${_PYTHON_PREFIX}_LIBRARIES})
      set(PYTHON_LIBRARIES ${${_PYTHON_PREFIX}_LIBRARIES})
      set(PYTHON_INCLUDE_DIR ${${_PYTHON_PREFIX}_INCLUDE_DIRS})
      set(PYTHON_INCLUDE_DIRS ${${_PYTHON_PREFIX}_INCLUDE_DIRS})
      set(PYTHON_VERSION_STRING ${${_PYTHON_PREFIX}_VERSION})
      set(PYTHONLIBS_VERSION_STRING ${${_PYTHON_PREFIX}_VERSION})
      set(PYTHON_FOUND ${${_PYTHON_PREFIX}_FOUND})
      set(PYTHONLIBS_FOUND ${${_PYTHON_PREFIX}_FOUND})
      set(PYTHON_VERSION_MAJOR ${${_PYTHON_PREFIX}_VERSION_MAJOR})
      set(PYTHON_VERSION_MINOR ${${_PYTHON_PREFIX}_VERSION_MINOR})
      set(PYTHON_VERSION_PATCH ${${_PYTHON_PREFIX}_VERSION_PATCH})
    else()
      message(FATAL_ERROR "Python executable has not been found.")
    endif()

  else(NOT CMAKE_VERSION VERSION_LESS "3.12" AND NOT WIN32)

    find_package(PythonInterp ${ARGN})
    if(NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)
      message(FATAL_ERROR "Python executable has not been found.")
    endif(NOT ${PYTHONINTERP_FOUND} STREQUAL TRUE)
    message(STATUS "PythonInterp: ${PYTHON_EXECUTABLE}")

    # Set PYTHON_INCLUDE_DIR variables if it is not defined by the user
    if(DEFINED PYTHON_EXECUTABLE AND NOT WIN32)
      # Retrieve the corresponding value of PYTHON_INCLUDE_DIR if it is not
      # defined
      if(NOT DEFINED PYTHON_INCLUDE_DIR)
        execute_process(
          COMMAND
            "${PYTHON_EXECUTABLE}" "-c"
            "import distutils.sysconfig as sysconfig; print(sysconfig.get_python_inc())"
          OUTPUT_VARIABLE PYTHON_INCLUDE_DIR
          ERROR_QUIET)
        string(STRIP "${PYTHON_INCLUDE_DIR}" PYTHON_INCLUDE_DIR)
      endif(NOT DEFINED PYTHON_INCLUDE_DIR)
      set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIR})
    endif(DEFINED PYTHON_EXECUTABLE AND NOT WIN32)

    message(STATUS "PYTHON_INCLUDE_DIRS:${PYTHON_INCLUDE_DIRS}")
    message(STATUS "PYTHON_INCLUDE_DIR:${PYTHON_INCLUDE_DIR}")

    # Inform PythonLibs of the required version of PythonInterp
    set(PYTHONLIBS_VERSION_STRING ${PYTHON_VERSION_STRING})

    find_package(PythonLibs ${ARGN})
    message(STATUS "PythonLibraries: ${PYTHON_LIBRARIES}")
    if(NOT ${PYTHONLIBS_FOUND} STREQUAL TRUE)
      message(FATAL_ERROR "Python has not been found.")
    endif(NOT ${PYTHONLIBS_FOUND} STREQUAL TRUE)

    string(REPLACE "." ";" _PYTHONLIBS_VERSION ${PYTHONLIBS_VERSION_STRING})
    list(GET _PYTHONLIBS_VERSION 0 PYTHONLIBS_VERSION_MAJOR)
    list(GET _PYTHONLIBS_VERSION 1 PYTHONLIBS_VERSION_MINOR)

    if(NOT ${PYTHON_VERSION_MAJOR} EQUAL ${PYTHONLIBS_VERSION_MAJOR}
       OR NOT ${PYTHON_VERSION_MINOR} EQUAL ${PYTHONLIBS_VERSION_MINOR})
      message(
        FATAL_ERROR
          "Python interpreter and libraries are in different version: ${PYTHON_VERSION_STRING} vs ${PYTHONLIBS_VERSION_STRING}"
      )
    endif(NOT ${PYTHON_VERSION_MAJOR} EQUAL ${PYTHONLIBS_VERSION_MAJOR}
          OR NOT ${PYTHON_VERSION_MINOR} EQUAL ${PYTHONLIBS_VERSION_MINOR})

  endif(NOT CMAKE_VERSION VERSION_LESS "3.12" AND NOT WIN32)

  # Find PYTHON_LIBRARY_DIRS
  get_filename_component(PYTHON_LIBRARY_DIRS "${PYTHON_LIBRARIES}" PATH)
  message(STATUS "PythonLibraryDirs: ${PYTHON_LIBRARY_DIRS}")
  message(STATUS "PythonLibVersionString: ${PYTHONLIBS_VERSION_STRING}")

  if(NOT PYTHON_SITELIB)
    # Use either site-packages (default) or dist-packages (Debian packages)
    # directory
    option(PYTHON_DEB_LAYOUT "Enable Debian-style Python package layout" OFF)
    # ref. https://docs.python.org/3/library/site.html
    option(PYTHON_STANDARD_LAYOUT "Enable standard Python package layout" OFF)

    if(PYTHON_STANDARD_LAYOUT)
      set(PYTHON_SITELIB_CMD
          "import sys, os; print(os.sep.join(['lib', 'python' + sys.version[:3], 'site-packages']))"
      )
    else(PYTHON_STANDARD_LAYOUT)
      set(PYTHON_SITELIB_CMD
          "from distutils import sysconfig; print(sysconfig.get_python_lib(prefix='', plat_specific=False))"
      )
    endif(PYTHON_STANDARD_LAYOUT)

    execute_process(
      COMMAND "${PYTHON_EXECUTABLE}" "-c" "${PYTHON_SITELIB_CMD}"
      OUTPUT_VARIABLE PYTHON_SITELIB
      OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)

    # Keep compatility with former jrl-cmake-modules versions
    if(PYTHON_DEB_LAYOUT)
      string(REPLACE "site-packages" "dist-packages" PYTHON_SITELIB
                     "${PYTHON_SITELIB}")
    endif(PYTHON_DEB_LAYOUT)

    # If PYTHON_PACKAGES_DIR is defined, then force the Python packages
    # directory name
    if(PYTHON_PACKAGES_DIR)
      string(REGEX
             REPLACE "(site-packages|dist-packages)" "${PYTHON_PACKAGES_DIR}"
                     PYTHON_SITELIB "${PYTHON_SITELIB}")
    endif(PYTHON_PACKAGES_DIR)
  endif(NOT PYTHON_SITELIB)

  message(STATUS "Python site lib: ${PYTHON_SITELIB}")

  # Get PYTHON_SOABI We should be in favor of using PYTHON_EXT_SUFFIX in future
  # for better portability. However we keep it here for backward compatibility.
  set(PYTHON_SOABI "")
  if(PYTHON_VERSION_MAJOR EQUAL 3 AND NOT WIN32)
    execute_process(
      COMMAND
        "${PYTHON_EXECUTABLE}" "-c"
        "from distutils.sysconfig import get_config_var; print('.' + get_config_var('SOABI'))"
      OUTPUT_VARIABLE PYTHON_SOABI)
    string(STRIP ${PYTHON_SOABI} PYTHON_SOABI)
  endif(PYTHON_VERSION_MAJOR EQUAL 3 AND NOT WIN32)

  # Get PYTHON_EXT_SUFFIX
  set(PYTHON_EXT_SUFFIX "")
  if(PYTHON_VERSION_MAJOR EQUAL 3)
    execute_process(
      COMMAND
        "${PYTHON_EXECUTABLE}" "-c"
        "from distutils.sysconfig import get_config_var; print(get_config_var('EXT_SUFFIX'))"
      OUTPUT_VARIABLE PYTHON_EXT_SUFFIX)
    string(STRIP ${PYTHON_EXT_SUFFIX} PYTHON_EXT_SUFFIX)
  endif(PYTHON_VERSION_MAJOR EQUAL 3)
  if("${PYTHON_EXT_SUFFIX}" STREQUAL "")
    if(WIN32)
      set(PYTHON_EXT_SUFFIX ".pyd")
    else()
      set(PYTHON_EXT_SUFFIX ".so")
    endif()
  endif()

  # Log Python variables
  list(
    APPEND
    LOGGING_WATCHED_VARIABLES
    PYTHONINTERP_FOUND
    PYTHONLIBS_FOUND
    PYTHON_LIBRARY_DIRS
    PYTHONLIBS_VERSION_STRING
    PYTHON_EXECUTABLE
    PYTHON_SOABI
    PYTHON_EXT_SUFFIX)

  set(Python_EXECUTABLE ${PYTHON_EXECUTABLE})
  set(Python_LIBRARY ${PYTHON_LIBRARY})
  set(Python_LIBRARIES ${PYTHON_LIBRARIES})
  set(Python_INCLUDE_DIR ${PYTHON_INCLUDE_DIR})
  set(Python_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
  set(Python_VERSION_STRING ${PYTHON_VERSION_STRING})
  set(PythonLIBS_VERSION_STRING ${PYTHONLIBS_VERSION_STRING})
  set(Python_FOUND ${PYTHON_FOUND})
  set(PythonLIBS_FOUND ${PYTHONLIBS_FOUND})
  set(Python_VERSION_MAJOR ${PYTHON_VERSION_MAJOR})
  set(Python_VERSION_MINOR ${PYTHON_VERSION_MINOR})
  set(Python_VERSION_PATCH ${PYTHON_VERSION_PATCH})

endmacro(FINDPYTHON)

# .rst: .. cmake:command:: DYNAMIC_GRAPH_PYTHON_MODULE ( SUBMODULENAME
# LIBRARYNAME TARGETNAME INSTALL_INIT_PY=1
# SOURCE_PYTHON_MODULE=cmake/dynamic_graph/python-module-py.cc)
#
# Add a python submodule to dynamic_graph
#
# :param SUBMODULENAME: the name of the submodule (can be foo/bar),
#
# :param LIBRARYNAME:   library to link the submodule with.
#
# :param TARGETNAME:     name of the target: should be different for several
# calls to the macro.
#
# :param INSTALL_INIT_PY: if set to 1 install and generated a __init__.py file.
# Set to 1 by default.
#
# :param SOURCE_PYTHON_MODULE: Location of the cpp file for the python module in
# the package. Set to cmake/dynamic_graph/python-module-py.cc by default.
#
# .. cmake:note:: Before calling this macro, set variable NEW_ENTITY_CLASS as
# the list of new Entity types that you want to be bound. Entity class name
# should match the name referencing the type in the factory.
#
macro(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME LIBRARYNAME TARGETNAME)

  # By default the __init__.py file is installed.
  set(INSTALL_INIT_PY 1)
  set(SOURCE_PYTHON_MODULE "cmake/dynamic_graph/python-module-py.cc")

  # Check if there is optional parameters.
  set(extra_macro_args ${ARGN})
  list(LENGTH extra_macro_args num_extra_args)
  if(${num_extra_args} GREATER 0)
    list(GET extra_macro_args 0 INSTALL_INIT_PY)
    if(${num_extra_args} GREATER 1)
      list(GET extra_macro_args 1 SOURCE_PYTHON_MODULE)
    endif(${num_extra_args} GREATER 1)
  endif(${num_extra_args} GREATER 0)

  if(NOT DEFINED PYTHONLIBS_FOUND)
    findpython()
  elseif(NOT ${PYTHONLIBS_FOUND} STREQUAL "TRUE")
    message(FATAL_ERROR "Python has not been found.")
  endif()

  set(PYTHON_MODULE ${TARGETNAME})
  # We need to set this policy to old to accept wrap target.
  cmake_policy(PUSH)
  if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
  endif()

  add_library(${PYTHON_MODULE} MODULE
              ${PROJECT_SOURCE_DIR}/${SOURCE_PYTHON_MODULE})

  file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/src/dynamic_graph/${SUBMODULENAME})

  set_target_properties(
    ${PYTHON_MODULE}
    PROPERTIES PREFIX ""
               OUTPUT_NAME dynamic_graph/${SUBMODULENAME}/wrap
               BUILD_RPATH ${DYNAMIC_GRAPH_PLUGINDIR})
  cmake_policy(POP)

  if(UNIX AND NOT APPLE)
    target_link_libraries(${PYTHON_MODULE} ${PUBLIC_KEYWORD}
                          "-Wl,--no-as-needed")
  endif(UNIX AND NOT APPLE)
  target_link_libraries(${PYTHON_MODULE} ${PUBLIC_KEYWORD} ${LIBRARYNAME}
                        ${PYTHON_LIBRARY})

  target_include_directories(${PYTHON_MODULE} SYSTEM
                             PRIVATE ${PYTHON_INCLUDE_DIRS})

  #
  # Installation
  #
  set(PYTHON_INSTALL_DIR ${PYTHON_SITELIB}/dynamic_graph/${SUBMODULENAME})

  install(TARGETS ${PYTHON_MODULE} DESTINATION ${PYTHON_INSTALL_DIR})

  set(ENTITY_CLASS_LIST "")
  foreach(ENTITY ${NEW_ENTITY_CLASS})
    set(ENTITY_CLASS_LIST "${ENTITY_CLASS_LIST}${ENTITY}('')\n")
  endforeach(ENTITY ${NEW_ENTITY_CLASS})

  # Install if INSTALL_INIT_PY is set to 1
  if(${INSTALL_INIT_PY} EQUAL 1)

    configure_file(
      ${PROJECT_SOURCE_DIR}/cmake/dynamic_graph/submodule/__init__.py.cmake
      ${PROJECT_BINARY_DIR}/src/dynamic_graph/${SUBMODULENAME}/__init__.py)

    install(
      FILES ${PROJECT_BINARY_DIR}/src/dynamic_graph/${SUBMODULENAME}/__init__.py
      DESTINATION ${PYTHON_INSTALL_DIR})

  endif(${INSTALL_INIT_PY} EQUAL 1)

endmacro(DYNAMIC_GRAPH_PYTHON_MODULE SUBMODULENAME)

# .rst: .. cmake:command::  PYTHON_INSTALL(MODULE FILE DEST)
#
# Compile and install a Python file.
#
macro(PYTHON_INSTALL MODULE FILE DEST)

  python_build("${MODULE}" "${FILE}")

  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/${FILE}"
          DESTINATION "${DEST}/${MODULE}")
endmacro()

# .rst: .. cmake:command:: PYTHON_INSTALL_ON_SITE (MODULE FILE)
#
# Compile and install a Python file in :cmake:variable:`PYTHON_SITELIB`.
#
macro(PYTHON_INSTALL_ON_SITE MODULE FILE)

  if(NOT DEFINED PYTHONLIBS_FOUND)
    findpython()
  elseif(NOT ${PYTHONLIBS_FOUND} STREQUAL "TRUE")
    message(FATAL_ERROR "Python has not been found.")
  endif()

  python_install("${MODULE}" "${FILE}" ${PYTHON_SITELIB})

endmacro()

# PYTHON_BUILD(MODULE FILE DEST)
# --------------------------------------
#
# Build a Python file from the source directory in the build directory.
#
macro(PYTHON_BUILD MODULE FILE)
  # Regex from IsValidTargetName in CMake/Source/cmGeneratorExpression.cxx
  string(REGEX REPLACE "[^A-Za-z0-9_.+-]" "_" compile_pyc
                       "compile_pyc_${CMAKE_CURRENT_SOURCE_DIR}")
  if(NOT TARGET ${compile_pyc})
    add_custom_target(${compile_pyc} ALL)
  endif()
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}")

  add_custom_command(
    TARGET ${compile_pyc}
    PRE_BUILD
    COMMAND
      "${PYTHON_EXECUTABLE}" "${PROJECT_SOURCE_DIR}/cmake/compile.py"
      "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}"
      "${MODULE}/${FILE}")

  # Tag pyc file as generated.
  set_source_files_properties("${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}c"
                              PROPERTIES GENERATED TRUE)

  # Clean generated files.
  set_property(
    DIRECTORY
    APPEND
    PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
             "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}c")
endmacro()

# PYTHON_INSTALL_BUILD(MODULE FILE DEST)
# --------------------------------------
#
# Install a Python file residing in the build directory and its associated
# compiled version.
#
macro(PYTHON_INSTALL_BUILD MODULE FILE DEST)

  message(
    AUTHOR_WARNING
      "PYTHON_INSTALL_BUILD is deprecated and will be removed in the future")
  message(AUTHOR_WARNING "Please use PYTHON_INSTALL_ON_SITE")
  message(
    AUTHOR_WARNING
      "ref https://github.com/jrl-umi3218/jrl-cmakemodules/issues/136")

  file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}")

  install(
    CODE "EXECUTE_PROCESS(COMMAND
    \"${PYTHON_EXECUTABLE}\"
    \"${PROJECT_SOURCE_DIR}/cmake/compile.py\"
    \"${CMAKE_CURRENT_BINARY_DIR}\"
    \"${CMAKE_CURRENT_BINARY_DIR}\"
    \"${MODULE}/${FILE}\")
    ")

  # Tag pyc file as generated.
  set_source_files_properties("${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}c"
                              PROPERTIES GENERATED TRUE)

  # Clean generated files.
  set_property(
    DIRECTORY
    APPEND
    PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
             "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}c")

  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}"
                "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/${FILE}c"
          DESTINATION "${DEST}/${MODULE}")
endmacro()

# .rst: .. cmake:command:: FIND_NUMPY
#
# Detect numpy module
#

macro(FIND_NUMPY)
  # Detect numpy.
  message(STATUS "checking for numpy")
  execute_process(
    COMMAND "${PYTHON_EXECUTABLE}" "-c"
            "import numpy; print (numpy.get_include())"
    OUTPUT_VARIABLE NUMPY_INCLUDE_DIRS
    ERROR_QUIET)
  if(NOT NUMPY_INCLUDE_DIRS)
    message(FATAL_ERROR "Failed to detect numpy")
  else()
    string(REGEX REPLACE "\n$" "" NUMPY_INCLUDE_DIRS "${NUMPY_INCLUDE_DIRS}")
    file(TO_CMAKE_PATH "${NUMPY_INCLUDE_DIRS}" NUMPY_INCLUDE_DIRS)
    message(STATUS " NUMPY_INCLUDE_DIRS=${NUMPY_INCLUDE_DIRS}")
  endif()
endmacro()
