#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

#.rst:
# .. cmake:command:: get_python_install_dir
#
# this macro creates the variable PYTHON_INSTALL_DIR which can
# be used to know where to install python bindings and packages
# we take the format used for default install of packages
# and just change to have the right prefix (CMAKE_INSTALL_PREFIX)
# 

macro(get_python_install_dir)
  find_package(Python REQUIRED COMPONENTS Interpreter Development)
  
  # code to find installation path for python libs
  set(_python_code
      "from distutils.sysconfig import get_python_lib"
      "import os"
      "print(os.path.relpath(get_python_lib(prefix='${CMAKE_INSTALL_PREFIX}'), start='${CMAKE_INSTALL_PREFIX}').replace(os.sep, '/'))"
  )
  execute_process(
    COMMAND
    "${Python_EXECUTABLE}"
    "-c"
    "${_python_code}"
    OUTPUT_VARIABLE _output
    RESULT_VARIABLE _result
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(NOT _result EQUAL 0)
    message(FATAL_ERROR
      "execute_process(${Python_EXECUTABLE} -c '${_python_code}') returned "
      "error code ${_result}"
    )
  endif()
  set(PYTHON_INSTALL_DIR
      "${_output}"
      CACHE INTERNAL
      "The directory for Python library installation. This needs to be in PYTHONPATH when 'setup.py install' is called."
  )
endmacro()
