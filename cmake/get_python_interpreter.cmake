
#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

# .rst: .. cmake:command:: get_python_interpreter
#
# Find the python interpreter and return it's location.
#
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