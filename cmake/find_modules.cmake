#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

#[=======================================================================[.rst:

Simply add the find_modules/* to the *CMAKE_MODULE_PATH*.

#]=======================================================================]

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/find_modules
                      ${CMAKE_MODULE_PATH})

if(CMAKE_VERSION VERSION_LESS "3.12")
  set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/find_modules/python
                        ${CMAKE_MODULE_PATH})
endif()
