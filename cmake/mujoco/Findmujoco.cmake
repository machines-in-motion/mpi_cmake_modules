

# assumes mujoco zip file (downloaded from mujoco's website)
# has been unzipped into /opt/mpi-is/ (i.e. folder /opt/mpi-is/mujoco200_linux exists)
# (documentation requests to unzip in /home/username/.mujoco, so we instruct here to
# do something different)

set(mujoco_INCLUDE_DIR "/opt/mpi-is/mujoco200_linux/include/")

if(NOT EXISTS ${mujoco_INCLUDE_DIR})
  message(FATAL_ERROR "failed to find mujoco200_linux in /opt/mpi-is/")
  set(mujoco_path_found FALSE)
endif()

set(mujoco_path_found TRUE)

if(mujoco_path_found)

  # Verify the information given.
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(
    mujoco
    REQUIRED_VARS mujoco_INCLUDE_DIR
    FOUND_VAR mujoco_FOUND)

  # Export the library.
  if(mujoco_FOUND)
    set(mujoco_LIBRARIES "")
    set(mujoco_LIBRARY "")
    set(mujoco_INCLUDE_DIRS ${mujoco_INCLUDE_DIR})
    set(mujoco_DEFINITIONS "")
  endif()

  if(mujoco_FOUND AND NOT TARGET mujoco::mujoco200)
    add_library(mujoco::mujoco200 INTERFACE IMPORTED)
    set_target_properties(
      mujoco::mujoco200 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
      "${mujoco_INCLUDE_DIR}")
  endif()

  if(mujoco_FOUND AND NOT TARGET mujoco::glew)
    add_library(mujoco::glew INTERFACE IMPORTED)
    set_target_properties(
      mujoco::glew PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
      "${mujoco_INCLUDE_DIR}")
  endif()

  if(mujoco_FOUND AND NOT TARGET mujoco::glewegl)
    add_library(mujoco::glewegl INTERFACE IMPORTED)
    set_target_properties(
      mujoco::glewegl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
      "${mujoco_INCLUDE_DIR}")
  endif()
  
  if(mujoco_FOUND AND NOT TARGET mujoco::glfw)
    add_library(mujoco::glfw INTERFACE IMPORTED)
    set_target_properties(
      mujoco::glfw PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
      "${mujoco_INCLUDE_DIR}")
  endif()

  mark_as_advanced(
    mujoco_INCLUDE_DIR
    mujoco_INCLUDE_DIRS
    mujoco_LIBRARY
    mujoco_LIBRARIES
    mujoco_DEFINITIONS
    mujoco_VERSION
    mujoco_FOUND)

endif()
