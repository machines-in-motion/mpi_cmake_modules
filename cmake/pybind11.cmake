#
# Copyright (c) 2019-2020, New York University and Max Planck Gesellschaft.
# License BSD-3 clause
#

#.rst:
#
# Add a Python module using pybind11
#
# .. cmake:command:: ADD_PYBIND11_MODULE
#
#    Add a pybind11 module.  Takes as argument the name of the module followed
#    by an optional list of libraries which are linked to the target.
#
#    This macro expects that the code is defined in a single source file
#    "srcpy/${module_name}.cpp"!
#
macro(add_pybind11_module module_name)
    pybind11_add_module(${module_name} srcpy/${module_name}.cpp)
    target_include_directories(${module_name} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    )
    target_link_libraries(${module_name} PRIVATE ${ARGN})
    install(TARGETS ${module_name}
        DESTINATION "${PYTHON_INSTALL_DIR}/${PROJECT_NAME}")
endmacro()


