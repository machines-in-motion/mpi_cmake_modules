#
# Copyright (c) 2019-2020, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#
# Get the resource files from the mpi_cmake_modules
#

# cmake-format: off
#
#.rst:
#
# .. cmake:command:: GET_RESOURCE_FOLDER
#
#     Get the path to resources from the mpi_cmake_modules.
#
# cmake-format: on
macro(GET_RESOURCE_FOLDER DESIRED_PROJECT_NAME RESOURCE_FOLDER)
  # Check using the ament index system.
  find_package(ament_cmake REQUIRED)
  ament_index_has_resource(RESOURCES_DIR_EXISTS resource_files
                           ${DESIRED_PROJECT_NAME})

  # First it might be a local resource folder we are looking for.
  if(${PROJECT_NAME} STREQUAL ${DESIRED_PROJECT_NAME})
    set(${RESOURCE_FOLDER} ${PROJECT_SOURCE_DIR}/resources)

    # Secondly the reources might have been installed using the ament_index
  elseif(RESOURCES_DIR_EXISTS)
    ament_index_get_resource(${RESOURCE_FOLDER} resource_files
                             ${DESIRED_PROJECT_NAME})

    # Otherwise there is a problem.
  elseif()
    message(
      FATAL_ERROR "The resource folder of the project ${DESIRED_PROJECT_NAME} "
                  "was not found.")
  endif()

endmacro()
