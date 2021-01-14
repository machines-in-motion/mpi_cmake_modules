"""utils
Utility functions for creating formatting scripts.

License BSD-3-Clause
Copyright (c) 2019, New York University and Max Planck Gesellschaft.
"""

import argparse
import sys
from os import path, walk

try:
    from shutil import which
except:
    import distutils.spawn

    ## This ensure the compatibility Python2 vs Python3
    which = distutils.spawn.find_executable


def test_valid_file(filename, extensions):
    """Test if the input file exists and is of one of the provided extension.

    Args:
        filename (str): Path to the file to test.

        extensions (str): iterable of accepted extensions.

    Returns:
        True if the file exits and ends with one of the extension.

        False otherwise.
    """
    if path.isfile(filename) and any(
        [filename.endswith(suffix) for suffix in extensions]
    ):
        return True
    else:
        return False


def get_absolute_path(file_or_directory):
    """Get the absolute path of a given path and check its existence

    Check if file_or_directory is an existing file or directory,
    if so, returns it. Otherwise, assumes it is a relative path,
    which it upgrades to an absolute path, this it returns. If the
    upgraded path does not correspond to an existing file or directory,
    returns None

    Args:
          file_or_directory: str `--` a relative or an absolute path

    Returns:
          an absolute existing path (str) or None
    """
    if path.isfile(file_or_directory) or path.isdir(file_or_directory):
        return file_or_directory
    fixed_path = os.path.abspath(file_or_directory)
    if path.isfile(fixed_path) or path.isdir(fixed_path):
        return fixed_path
    return None


def list_of_files_to_format(files_or_directories, extensions):
    """Get the list of files to format exploring the input arguments.

    Explore recursively the directories given in the input list and create
    a list of all files. Add to this list the files given in the input list.
    Sort out the files that are source-files or not and return the list
    of source files.

    Args:
        files_or_directories: list(str) `--` List of files or directories.

        extensions: list(str) `--` List of extensions to check against

    Returns:
        True if the file ends with one of the given extensions, typically:
        (".h", ".c", ".hh", ".cc", ".hpp", ".cpp", ".hxx", ".cxx")

        False otherwise.
    """
    fixed = [get_absolute_path(fod) for fod in files_or_directories]
    for original, fix in zip(files_or_directories, fixed):
        if fix is None:
            raise Exception("failed to find: " + str(original))
    files_or_directories = fixed
    list_of_files = []
    for file_or_directory in files_or_directories:
        if test_valid_file(file_or_directory, extensions):
            list_of_files.append(file_or_directory)
        elif path.isdir(file_or_directory):
            for (dirpath, _, filenames) in walk(file_or_directory):
                for filename in filenames:
                    if test_valid_file(
                        path.join(dirpath, filename), extensions
                    ):
                        list_of_files.append(path.join(dirpath, filename))
    return list_of_files


def parse_args(sys_args):

    # Parser for the input arguments
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "files_or_folders",
        type=str,
        nargs="+",
        help="List of source files or folders.",
    )

    # Input arguments.
    return parser.parse_args()
