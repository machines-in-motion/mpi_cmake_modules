#
# @file @copyright Copyright (c) 2019, New York University and Max Planck
# Gesellschaft. @license License BSD-3 clause @date 2019-05-06
#
# @brief This file allow building the documentation using cmake
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

macro(BUILD_DOCUMENTATION)

  build_doxygen_documentation()
  build_sphinx_documentation()

endmacro(BUILD_DOCUMENTATION)
