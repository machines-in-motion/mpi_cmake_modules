#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# License BSD-3 clause
#

#.rst:
# .. cmake:command:: CREATE_DOC_TARGET
#
#   Create a target called `doc`. This target allows you do perform::
#       
#       make doc
#
#   This target is created by default in the `cmake/global_calls.cmake`. It can
#   be built by default if one set the CMake variable `GENERATE_DOCUMENTATION`
#   to on::
#
#       cmake .. -DGENERATE_DOCUMENTATION=ON
#
macro(CREATE_DOC_TARGET)
  option(GENERATE_DOCUMENTATION
         "This allow the docuementation to be build by default." OFF)

  if(NOT TARGET doc)
    if(GENERATE_DOCUMENTATION)
      add_custom_target(doc ALL)
    else()
      add_custom_target(doc)
    endif()
  endif(NOT TARGET doc)

endmacro(CREATE_DOC_TARGET)

#.rst:
# .. cmake:command:: BUILD_DOCUMENTATION
#
#   Create targets that are dependencies to the `doc` target. It builds the
#   documentation html output using the classic Doxygen output and the rather
#   more modern Sphinx/Read-the-doc output. Eventually only the read-the-doc
#   output will remain.
#
macro(BUILD_DOCUMENTATION)

  build_doxygen_documentation()
  build_sphinx_documentation()

endmacro(BUILD_DOCUMENTATION)
