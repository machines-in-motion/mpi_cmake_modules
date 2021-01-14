""" @namespace mpi_cmake_modules.black_format.py

Utility functions for creating formatting script based on clang 
@file black_format.py
@license License BSD-3-Clause
@copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
"""

import argparse
import sys
import os
from os import walk
from os import path

try:
    from shutil import which
except:
    import distutils.spawn

    ## This ensure the compatibility Python2 vs Python3
    which = distutils.spawn.find_executable


def find_black_format():
    """Find the full path to the clang-format executable.

    Look by default for the `clang-format` executable in the PATH environment
    variable.

    Args:
        name_list: list(str) `--` Potential executable names which might differ
        according to the clang-format version available.

    Returns:
        The full path to the clang-format executable.
    """
    path_to_black = which("black")
    if path_to_black is not None:
        return path_to_black
    raise Exception(
        "black executable not found. You may try "
        "'(sudo -H) pip install install black'"
    )


def execute_black_format(
    black_format_bin, list_of_files=None, list_of_directories=None
):
    """Execute the formatting of python files using black.

    Get the path to the executable, and run it on the list of files to format.

    Args:
        black_format_bin (str):  Path to the black binary.

        black_format_config (list(str)): One line dictionnary string containing
        the black parameters.

        black_format_arg list(str): List of source files to parse.
    """
    arg_files = ""
    if list_of_files is not None:
        arg_files = " --pyi " + " ".join(list_of_files)

    arg_folder = ""
    if list_of_directories is not None:
        arg_folder = " ".join(list_of_directories)

    # Format files
    cmd = " ".join(
        [
            black_format_bin,
            "--line-length 79",
            arg_folder,
            arg_files,
            "--verbose",
        ]
    )
    try:
        print("\nexecuting: ")
        print(cmd)
        print("")
        os.system(cmd)
    except Exception as e:
        print("Fail to call " + black_format_bin + " with error:")
        print(e)
