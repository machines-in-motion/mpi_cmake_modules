#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft. License
# BSD-3 clause
#

#[=======================================================================[.rst:
FindPython
----------

Finds the Python library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Python::Python``
  The Python interface library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Python_FOUND``
  True if the system has the Python library.
``Python_VERSION``
  The version of the Python library which was found.
``Python_INCLUDE_DIRS``
  Include directories needed to use Python.
``Python_LIBRARIES``
  Libraries needed to link to Python. This will be empty as this is a header
  only library.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Python_INCLUDE_DIR``
  The directory containing ``Python.h``.
``Python_LIBRARY``
  The path to the Python library.

#]=======================================================================]

if(python_INCLUDE_DIRS
   AND python_INCLUDE_DIR
   AND Python_LIBRARIES)
  if(EXISTS ${python_INCLUDE_DIRS}
     AND EXISTS ${python_INCLUDE_DIR}
     AND EXISTS ${Python_LIBRARIES})
    message(STATUS "Python already found just export the target.")
  elseif()
    findpython()
  endif()
endif()

# Export the library.
if(Python_FOUND)

  set(Python_target_name Python::Python)
  if(NOT TARGET ${Python_target_name})
    add_library(${Python_target_name} IMPORTED)
    set_target_properties(
      ${Python_target_name}
      PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Python_INCLUDE_DIR}"
                 IMPORTED_LOCATION "${Python_LIBRARIES}")
  endif()

endif()
