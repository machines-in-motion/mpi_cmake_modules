#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft. License
# BSD-3 clause
#

#.rst:
# .. cmake:command:: DYNAMIC_GRAPH_PYTHON_MODULE ( target_name)
#
#   This file allows us to install the Python bindings of the dynamic graph at the
#   correct place.
#
#   Add a python submodule to dynamic_graph
#
#   :param plugin_target: target (library) name of the dynamic graph plugin,
#
macro(INSTALL_DYNAMIC_GRAPH_PLUGIN PLUGIN_TARGET)
  #
  # Install the plugin target
  #

  # This is a plugin so no "lib" as prefix.
  set_target_properties(PLUGIN_TARGET PROPERTIES PREFIX "")
  install(TARGETS PLUGIN_TARGET DESTINATION lib/dynamic_graph_plugins)

  #
  # Install the plugin python bindings
  #

  # Look for the python install directory
  find_package(ament_cmake_python REQUIRED)
  _ament_cmake_python_get_python_install_dir()
  set(plugin_install_dir ${PYTHON_INSTALL_DIR}/${PORJECT_NAME}/dynamic_graph)

  # Get the Python installation.
  if(NOT DEFINED PYTHONLIBS_FOUND)
    findpython()
  elseif(NOT ${PYTHONLIBS_FOUND} STREQUAL "TRUE")
    message(FATAL_ERROR "Python has not been found.")
  endif()

  # create the library
  set(PYTHON_MODULE "${TARGET_NAME}_cpp_bindings")
  configure_file(${MPI_CMAKE_MODULES_RESOURCES_DIR}/python-module-py.cc.in
                 ${PROJECT_BINARY_DIR}/python-module-py.cc @ONLY IMMEDIATE)
  add_library(${PYTHON_MODULE} MODULE ${PROJECT_BINARY_DIR}/python-module-py.cc)
  message(STATUS "Creating the python binding of: ${TARGET_NAME}")
  target_link_libraries(${PYTHON_MODULE} ${TARGET_NAME} ${PYTHON_LIBRARY})
  set_target_properties(${PYTHON_MODULE} PROPERTIES PREFIX "")
  install(TARGETS ${PYTHON_MODULE} DESTINATION ${plugin_install_dir})

  # Create an empty __init__.py in the <python_install_dir>/dynamic_graph folder
  install(
    FILES ${MPI_CMAKE_MODULES_RESOURCES_DIR}/__init__.py.empty.in
    RENAME __init__.py
    DESTINATION plugin_install_dir)

  configure_file(${MPI_CMAKE_MODULES_RESOURCES_DIR}/__init__.py.in
                 ${OUTPUT_MODULE_DIR}/__init__.py)

  set(ENTITY_CLASS_LIST "")
  foreach(ENTITY ${NEW_ENTITY_CLASS})
    set(ENTITY_CLASS_LIST "${ENTITY_CLASS_LIST}${ENTITY}('')\n")
  endforeach(ENTITY ${NEW_ENTITY_CLASS})

endmacro(INSTALL_DYNAMIC_GRAPH_PLUGIN PLUGIN_TARGET)
