""" python_format

Utility functions for creating formatting script based on clang 

License BSD-3-Clause
Copyright (c) 2019, New York University and Max Planck Gesellschaft.
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

from mpi_cmake_modules.utils import parse_args


def _find_black():
    """Find the full path to the clang-format executable.

    Look by default for the `black` executable in the PATH environment
    variable.

    Returns:
        The full path to the black executable.
    """
    path_to_black = which("black")
    if path_to_black is not None:
        return path_to_black
    raise Exception(
        "black executable not found. You may try "
        "'(sudo -H) pip install install black'"
    )


def _execute_black(
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


def run_python_format(sys_args):
    print("Formatting Python files...")

    args = parse_args(sys_args)

    list_of_files = []
    list_of_directories = []
    for file_or_folder in args.files_or_folders:
        if path.isfile(file_or_folder):
            list_of_files.append(file_or_folder)
        elif path.isdir(file_or_folder):
            list_of_directories.append(file_or_folder)

    if not list_of_files:
        list_of_files = None
    if not list_of_directories:
        list_of_directories = None

    black_bin = _find_black()
    _execute_black(black_bin, list_of_files, list_of_directories)

    print("Formatting Python files... Done")
    print("")
