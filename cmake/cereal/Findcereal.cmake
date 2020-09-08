#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft. License
# BSD-3 clause
#

#[=======================================================================[.rst:
FindCereal
----------

Finds the Cereal library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Cereal::Cereal``
  The Cereal interface library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Cereal_FOUND``
  True if the system has the Cereal library.
``Cereal_VERSION``
  The version of the Cereal library which was found.
``Cereal_INCLUDE_DIRS``
  Include directories needed to use Cereal.
``Cereal_LIBRARIES``
  Libraries needed to link to Cereal. This will be empty as this is a header
  only library.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Cereal_INCLUDE_DIR``
  The directory containing ``Cereal.h``.
``Cereal_LIBRARY``
  The path to the Cereal library.

#]=======================================================================]

set(cereal_error_message "Could not find 'cereal', the serialization library. "
                         "Please try 'sudo apt install libcereal-dev'")

find_path(cereal_INCLUDE_DIR cereal HINTS /usr/include/cereal /usr/include/)
if(cereal_INCLUDE_DIR STREQUAL "cereal_INCLUDE_DIR-NOTFOUND")
  message(FATAL_ERROR ${cereal_error_message})
  set(cereal_path_found FALSE)
endif()

set(cereal_path_found TRUE)

if(cereal_path_found)

  # Verify the information given.
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(
    cereal
    REQUIRED_VARS cereal_INCLUDE_DIR
    FOUND_VAR cereal_FOUND)

  # Export the library.
  if(cereal_FOUND)
    set(cereal_LIBRARIES "")
    set(cereal_LIBRARY "")
    set(cereal_INCLUDE_DIRS ${cereal_INCLUDE_DIR})
    set(cereal_DEFINITIONS "")
  endif()

  set(cereal_target_name cereal::cereal)
  if(cereal_FOUND AND NOT TARGET ${cereal_target_name})
    add_library(${cereal_target_name} INTERFACE IMPORTED)
    set_target_properties(
      ${cereal_target_name} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                       "${cereal_INCLUDE_DIR}")
  endif()

  mark_as_advanced(
    cereal_INCLUDE_DIR
    cereal_INCLUDE_DIRS
    cereal_LIBRARY
    cereal_LIBRARIES
    cereal_DEFINITIONS
    cereal_VERSION
    cereal_FOUND)

endif()
