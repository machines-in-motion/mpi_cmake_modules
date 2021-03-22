#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

include(${CMAKE_CURRENT_LIST_DIR}/get_python_interpreter.cmake)

# .rst: .. cmake:command:: get_python_install_dir
#
# This macro creates the variable PYTHON_INSTALL_DIR which can be used to know
# where to install python bindings and packages we take the format used for
# default install of packages and just change to have the right prefix
# (CMAKE_INSTALL_PREFIX)
#
function(get_python_install_dir output)

  # Find the python interpreter.
  if(NOT PYTHON_EXECUTABLE)
    find_program(PYTHON_EXECUTABLE "python")
  endif()

  set(PYTHON_VERSION
      ""
      CACHE STRING
            "Specify specific Python version to use ('major.minor' or 'major')")
  # if not specified otherwise use Python 3
  if(NOT PYTHON_VERSION)
    set(PYTHON_VERSION "3")
  endif()
  message(STATUS "Using PYTHON_EXECUTABLE: ${PYTHON_EXECUTABLE}")

  # code to find installation path for python libs
  set(_python_code
      "from distutils.sysconfig import get_python_lib"
      "import os"
      "install_path = '${CMAKE_INSTALL_PREFIX}'"
      "python_lib = get_python_lib(prefix=install_path)"
      "rel_path = os.path.relpath(python_lib, start=install_path)"
      "print(rel_path.replace(os.sep, '/'))")
  execute_process(
    COMMAND "${PYTHON_EXECUTABLE}" "-c" "${_python_code}"
    OUTPUT_VARIABLE _output
    RESULT_VARIABLE _result
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT _result EQUAL 0)
    message(
      FATAL_ERROR
        "execute_process(${PYTHON_EXECUTABLE} -c '${_python_code}') returned "
        "error code ${_result}")
  endif()
  set(${output}
      "${_output}"
      PARENT_SCOPE)
endfunction()
