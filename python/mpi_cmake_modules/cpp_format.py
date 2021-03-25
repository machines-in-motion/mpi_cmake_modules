"""cpp_format.py

Formatting script based on clang .

License BSD-3-Clause
Copyright (c) 2021, New York University and Max Planck Gesellschaft.
"""

import os
from os import walk
from os import path

import mpi_cmake_modules
from mpi_cmake_modules.yaml2oneline import yaml2oneline
from mpi_cmake_modules.utils import (
    list_of_files_to_format,
    which,
    code_formatter_parse_args,
)


def _find_clang_format(name_list=["clang-format"]):
    """Find the full path to the clang-format executable.

    Look by default for the `clang-format` executable in the PATH environment
    variable.

    Args:
        name_list: list(str) `--` Potential executable names which might differ
        according to the clang-format version available.

    Returns:
        The full path to the clang-format executable.
    """
    for name in name_list:
        path_to_clang_format = which(name)
        if path_to_clang_format is not None:
            return path_to_clang_format
    raise Exception(
        "clang-format executable not found. You may try "
        "'sudo apt-get install clang-format'"
    )


def _load_clang_format_config():
    """Look for the clang-format parameter file in this package.

    Look for the _clang-format file located in this package and convert it
    in a one line dictionnary string.

    Returns:
        The _clang-format in a online dictionnary string.
    """
    for module_path in mpi_cmake_modules.__path__:
        for (dirpath, _, filenames) in walk(
            path.join(module_path, "resources")
        ):
            if "_clang-format" in filenames:
                return yaml2oneline(path.join(dirpath, "_clang-format"))
            break
    raise Exception(
        "failed to find _clang-format file in "
        + str(mpi_cmake_modules.__path__)
    )


def _execute_clang_format(
    clang_format_bin, clang_format_config, clang_format_arg
):
    """Execute the formatting of C/C++ files using clang-format.

    Get the path to the executable, and run it using the clang-format insput
    parameter on the list of files to format.

    Args:
        clang_format_bin (str):  Path to the clang-format binary.

        clang_format_config (list(str)): One line dictionnary string containing
        the clang-format parameters.

        clang_format_arg list(str): List of source files to parse.
    """

    cmd = " ".join(
        [
            clang_format_bin,
            ' -style="' + clang_format_config + '"',
            " -i " + " ".join(clang_format_arg),
        ]
    )
    try:
        print("\nexecuting: ")
        print(cmd)
        print("")
        os.system(cmd)
    except Exception as e:
        print("Fail to call " + clang_format_bin + " with error:")
        print(e)


def run_cpp_format(sys_args):
    print("Formatting C/C++ files...")

    args = code_formatter_parse_args(sys_args)

    extensions = (".h", ".c", ".hh", ".cc", ".hpp", ".cpp", ".hxx", ".cxx")

    # Path to the clang-format binary.
    clang_format_bin = _find_clang_format(
        ["clang-format", "clang-format-6.0", "clang-format-8"]
    )

    # clang-format parameters.
    clang_format_config = _load_clang_format_config()
    # List of files or directories to parse.
    list_of_files = list_of_files_to_format(args.files_or_folders, extensions)

    if not list_of_files:
        print("\nNo C/C++ file to format in the given paths.\n")
        return
    else:
        print("\nFormatting:")
        for f in list_of_files:
            print("\t" + str(f))
        print("")

    _execute_clang_format(clang_format_bin, clang_format_config, list_of_files)

    print("Formatting C/C++ files... Done")
    print("")
