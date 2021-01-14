""" @namespace mpi_cmake_modules.cmake_format.py

Formatting script based on cmake-format

License BSD-3-Clause
Copyright (c) 2019, New York University and Max Planck Gesellschaft.
"""

import os
from os import walk
from os import path

import mpi_cmake_modules
from mpi_cmake_modules.utils import (
    list_of_files_to_format,
    which,
    parse_args,
)


def _load_cmake_format_config():
    """Look for the cmake-format parameter file in this package.

    Look for the _cmake-format file located in this package and convert it
    in a one line dictionnary string.

    Returns:
        The _cmake-format in a online dictionnary string.
    """
    for module_path in mpi_cmake_modules.__path__:
        for (dirpath, _, filenames) in walk(module_path):
            if "_cmake-format" in filenames:
                return yaml2oneline(path.join(dirpath, "_cmake-format"))
            break
    raise Exception(
        "failed to find _cmake-format file in "
        + str(mpi_cmake_modules.__path__)
    )


def _execute_cmake_format(cmake_format_bin, list_of_files):
    """Execute the formatting of C/C++ files using cmake-format.

    Get the path to the executable, and run it using the cmake-format insput
    parameter on the list of files to format.

    Args:
        cmake_format_bin (str):  Path to the cmake-format binary.

        cmake_format_config (list(str)): One line dictionnary string containing
        the cmake-format parameters.

        cmake_format_arg list(str): List of source files to parse.
    """

    for file_to_format in list_of_files:
        cmd = " ".join(
            [
                cmake_format_bin,
                file_to_format,
                "--outfile-path " + file_to_format,
            ]
        )
        try:
            print("\nexecuting: ")
            print(cmd)
            print("")
            os.system(cmd)
        except Exception as e:
            print("Fail to call " + cmake_format_bin + " with error:")
            print(e)


def run_cmake_format(sys_args):
    print("Formatting CMake files.")

    args = parse_args(sys_args)

    # Path to the cmake-format binary.
    cmake_format_bin = which("cmake-format")
    if cmake_format_bin is None:
        raise Exception(
            "cmake-format executable not found. You may try "
            "'sudo apt-get install cmake-format'"
        )

    # List of files or directories to parse.
    extensions = ("CMakeLists.txt", ".cmake")
    list_of_files = list_of_files_to_format(args.files_or_folders, extensions)

    if not list_of_files:
        print("\nNo CMake file to format in the given paths.\n")
        return
    else:
        print("\nFormatting:")
        for f in list_of_files:
            print("\t" + str(f))
        print("")

    _execute_cmake_format(cmake_format_bin, list_of_files)
