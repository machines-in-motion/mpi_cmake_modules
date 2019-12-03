#
# @file clang-format.cmake
# @author Maximilien Naveau
# @copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# @license License BSD-3 clause
# @date 2019-10-16
#
#===============================================================================
# Code Formatting
#===============================================================================

MACRO(FORMAT_CODE)

    option(FORMAT_CODE_DURING_BUILD "Set to ON if you want to format your code automatically during the build" OFF)

    if(${FORMAT_CODE_DURING_BUILD})
        message(STATUS "[ Code Formatting ]")
        find_program(
            CLANG_FORMAT_EXECUTABLE
            NAMES clang-format
        )
        if(CLANG_FORMAT_EXECUTABLE)
            message(STATUS "Looking for clang-format - found")
            message(STATUS "Format source files using catkin_make format.")
            configure_file(${mpi_cmake_modules_SOURCE_DIR}/resources/.clang-format.in
                        ${CMAKE_CURRENT_SOURCE_DIR}/.clang_format @ONLY IMMEDIATE)
            add_custom_target(${PROJECT_NAME}-format ALL
                            COMMAND ${CMAKE_COMMAND} -E echo "Formatting files... "
                            COMMAND ${mpi_cmake_modules_SOURCE_DIR}/resources/format.sh ${CLANG_FORMAT_EXECUTABLE}
                            COMMAND ${CMAKE_COMMAND} -E echo "Done."
                            DEPENDS ${CLANG_FORMAT_EXECUTABLE}
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
            add_custom_target(${PROJECT_NAME}-check-format ALL
                COMMAND ${CMAKE_COMMAND} -E echo "Checking files... "
                COMMAND ${mpi_cmake_modules_SOURCE_DIR}/resources/check_format.sh ${CLANG_FORMAT_EXECUTABLE}
                COMMAND ${CMAKE_COMMAND} -E echo "Done."
                DEPENDS ${CLANG_FORMAT_EXECUTABLE}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
        else()
            message(WARNING "Looking for clang-format - NOT found, please install clang-format to enable automatic code formatting")
        endif()
    endif()
  
ENDMACRO(FORMAT_CODE)