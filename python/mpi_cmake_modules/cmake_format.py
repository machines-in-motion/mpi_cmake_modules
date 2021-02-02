""" @namespace mpi_cmake_modules.cmake_format.py

Formatting script based on cmake-format

License BSD-3-Clause
Copyright (c) 2021, New York University and Max Planck Gesellschaft.
"""

import os
from mpi_cmake_modules.utils import (
    list_of_files_to_format,
    which,
    code_formatter_parse_args,
)


def _execute_cmake_format(cmake_format_bin, list_of_files):
    """Execute the formatting of CMake files using cmake-format.

    Get the path to the executable, and run it using the cmake-format insput
    parameter on the list of files to format.

    Args:
        cmake_format_bin (str):  Path to the cmake-format binary.

        list_of_files list(str): List of source files to parse.
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
            print("executing: ", end="")
            print(cmd)
            os.system(cmd)
        except Exception as e:
            print("Fail to call " + cmake_format_bin + " with error:")
            print(e)


def run_cmake_format(sys_args):
    print("Formatting CMake files...")

    args = code_formatter_parse_args(sys_args)

    # Path to the cmake-format binary.
    cmake_format_bin = which("cmake-format")
    if cmake_format_bin is None:
        raise Exception(
            "cmake-format executable not found. You may try "
            "'pip install cmake-format'"
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

    print("Formatting CMake files ... Done")
    print("")
