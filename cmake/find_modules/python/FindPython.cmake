
set(PYTHON_VERSION "" CACHE STRING
  "Specify specific Python version to use ('major.minor' or 'major')")
# if not specified otherwise use Python 3
if(NOT PYTHON_VERSION)
  set(PYTHON_VERSION "3")
endif()

find_package(PythonInterp ${PYTHON_VERSION} REQUIRED)
message(STATUS "Using PYTHON_EXECUTABLE: ${PYTHON_EXECUTABLE}")

find_package(PythonLibs ${PYTHON_VERSION} REQUIRED)

message(STATUS "FindPython has found:")
message(STATUS "    - PYTHON_EXECUTABLE: ${PYTHON_EXECUTABLE}")
message(STATUS "    - PYTHON_INCLUDE_DIR: ${PYTHON_INCLUDE_DIR}")
message(STATUS "    - PYTHON_LIBRARIES: ${PYTHON_LIBRARIES}")
