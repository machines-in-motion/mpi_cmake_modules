#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

# cmake-format: off
#.rst:
# .. cmake:command:: DYNAMIC_GRAPH_PYTHON_MODULE ( PLUGIN_TARGET)
#
#   This file allows us to install the Python bindings of the dynamic graph at
#   the correct place.
#
#   Add a python submodule to dynamic_graph
#
#   :param plugin_target: target (library) name of the dynamic graph plugin,
# cmake-format: on
macro(INSTALL_DYNAMIC_GRAPH_PLUGIN PLUGIN_TARGET)
  #
  # Install the plugin target
  #

  # This is a plugin so no "lib" as prefix.
  set_target_properties(${PLUGIN_TARGET} PROPERTIES PREFIX "")
  install(TARGETS ${PLUGIN_TARGET} DESTINATION lib/dynamic_graph_plugins)

  #
  # Install the plugin python bindings
  #
  message(STATUS "Creating the python binding of: ${PLUGIN_TARGET}")

  # Get the mpi_cmake_modules resource folder
  ament_index_has_resource(MPI_CMAKE_MODULES_RESOURCES_DIR_EXISTS
                           resource_files mpi_cmake_modules)
  if(MPI_CMAKE_MODULES_RESOURCES_DIR_EXISTS)
    ament_index_get_resource(MPI_CMAKE_MODULES_RESOURCES_DIR resource_files
                             mpi_cmake_modules)
  elseif()
    set(MPI_CMAKE_MODULES_RESOURCES_DIR ${PROJECT_SOURCE_DIR}/resources)
  endif()

  # Look for the python install directory
  find_package(ament_cmake_python REQUIRED)
  _ament_cmake_python_get_python_install_dir()
  set(plugin_install_dir ${PYTHON_INSTALL_DIR}/${PROJECT_NAME}/dynamic_graph)

  # Get the Python installation.
  if(NOT DEFINED PYTHONLIBS_FOUND)
    find_package(Python REQUIRED)
  elseif(NOT ${PYTHONLIBS_FOUND} STREQUAL "TRUE")
    message(FATAL_ERROR "Python has not been found.")
  endif()

  # create the library
  set(PYTHON_MODULE "${PLUGIN_TARGET}_cpp_bindings")
  set(DYNAMIC_GRAPH_PLUGIN_CPP_BINDINGS ${PYTHON_MODULE})
  configure_file(
    ${MPI_CMAKE_MODULES_RESOURCES_DIR}/python-module-py.cc.in
    ${PROJECT_BINARY_DIR}/${PYTHON_MODULE}_python-module-py.cc @ONLY IMMEDIATE)
  add_library(${PYTHON_MODULE} MODULE
              ${PROJECT_BINARY_DIR}/${PYTHON_MODULE}_python-module-py.cc)
  target_include_directories(${PYTHON_MODULE} PUBLIC ${Python_INCLUDE_DIR}
                                                     ${PYTHON_INCLUDE_DIR})
  target_link_libraries(${PYTHON_MODULE} ${PLUGIN_TARGET} ${PYTHON_LIBRARY}
                        ${python_LIBRARY})
  set_target_properties(${PYTHON_MODULE} PROPERTIES PREFIX "")
  set_target_properties(
    ${PYTHON_MODULE}
    PROPERTIES
      INSTALL_RPATH
      "${CMAKE_INSTALL_RPATH}:${CMAKE_INSTALL_PREFIX}/lib/dynamic_graph_plugins"
  )
  install(TARGETS ${PYTHON_MODULE} DESTINATION ${plugin_install_dir})

  # Create an empty __init__.py in the <python_install_dir>/dynamic_graph folder
  install(
    FILES ${MPI_CMAKE_MODULES_RESOURCES_DIR}/__init__.py.empty.in
    RENAME __init__.py
    DESTINATION ${plugin_install_dir})

  configure_file(
    ${MPI_CMAKE_MODULES_RESOURCES_DIR}/dynamic_graph_plugin_loader.py.in
    ${CMAKE_BINARY_DIR}/${PLUGIN_TARGET}.py)
  install(FILES ${CMAKE_BINARY_DIR}/${PLUGIN_TARGET}.py
          DESTINATION ${plugin_install_dir})

  set(ENTITY_CLASS_LIST "")
  foreach(ENTITY ${NEW_ENTITY_CLASS})
    set(ENTITY_CLASS_LIST "${ENTITY_CLASS_LIST}${ENTITY}('')\n")
  endforeach(ENTITY ${NEW_ENTITY_CLASS})

endmacro(INSTALL_DYNAMIC_GRAPH_PLUGIN PLUGIN_TARGET)
