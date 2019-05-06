##########################
# building documentation #
##########################
macro(build_doxygen_documentation)
  
  set(BUILD_DOCUMENTATION OFF CACHE BOOL
      "Set to ON if you want to build the documentation")
  if(BUILD_DOCUMENTATION)
  
    message(STATUS "building doxygen documentation for ${PROJECT_NAME}")

    # Find "doxygen"
    find_package(Doxygen)
    if (NOT DOXYGEN_FOUND)
      message(FATAL_ERROR
          "Doxygen is needed to build the documentation. "
          "Please install it correctly")
    endif()

    # set the destination folder to be devel/share/[project_name]/doc/
    set(doc_build_folder ${PROJECT_BINARY_DIR})
    set(doc_install_folder ${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION})
    
    # Create the doxyfile in function of the current project.
    # If the Doxyfile.in does not exists, the cmake step stops.
    configure_file(Doxyfile.in ${doc_build_folder}/Doxyfile  @ONLY IMMEDIATE)
    
    # the doxygen target is generated
    add_custom_target (${PROJECT_NAME}_doc ALL
      COMMAND ${DOXYGEN_EXECUTABLE} ${doc_build_folder}/Doxyfile
      SOURCES ${doc_build_folder}/Doxyfile)

    message(WARNING "doc folder = " ${doc_build_folder}/doc "            doc install fodler = " ${doc_install_folder})
    message(WARNING "CMAKE_PREFIX_PATH = " ${CMAKE_PREFIX_PATH})
    message(WARNING "CMAKE_INSTALL_PREFIX = " ${CMAKE_INSTALL_PREFIX})
    # install the documentation    
    install(DIRECTORY ${doc_build_folder}/doc DESTINATION ${doc_install_folder})
  
  endif(BUILD_DOCUMENTATION)

endmacro(build_doxygen_documentation)