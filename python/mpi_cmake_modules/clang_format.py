#!/usr/bin/env python
"""Execute a clang-format on a desired file or folder.

Example:
    1/ rosrun mpi_cmake_module clang_format /path/to/format
    2/ rosrun mpi_cmake_module clang_format file_to_format.ext
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
    which = distutils.spawn.find_executable
import mpi_cmake_modules
from mpi_cmake_modules.yaml2oneline import yaml2oneline


def find_clang_format(name_list=['clang-format']):
    """ Find the full path to the clang-format executable. """
    for name in name_list:
        path_to_clang_format = which(name)
        if path_to_clang_format is not None:
            return path_to_clang_format
    raise Exception("clang-format executable not found. You may try 'sudo apt-get install clang-format'")
    
        

def load_clang_format_config():
    for module_path in mpi_cmake_modules.__path__:
        for (dirpath, _, filenames) in walk(module_path):
            if "_clang-format" in filenames:
                return yaml2oneline(path.join(dirpath, "_clang-format"))
            break


def test_valid_file(filename):
    if (path.isfile(filename) and any([filename.endswith(suffix) for suffix in
                                       (".h", ".c", ".hh", ".cc", ".hpp",
                                        ".cpp", ".hxx", ".cxx")])):
        return True
    else:
        return False


def list_of_files_to_format(files_or_directories):
    list_of_files = []
    for file_or_directory in files_or_directories:
        if test_valid_file(file_or_directory):
            list_of_files.append(file_or_directory)
        elif path.isdir(file_or_directory):
            for (dirpath, _, filenames) in walk(file_or_directory):
                for filename in filenames:
                    if test_valid_file(path.join(dirpath, filename)):
                        list_of_files.append(path.join(dirpath, filename))
    return list_of_files


def execute_clang_format(clang_format_bin, clang_format_config,
                         clang_format_arg):
    
    cmd = ' '.join([clang_format_bin,
          ' -style="' + clang_format_config + '"',
          ' -i ' + ' '.join(clang_format_arg)
          ])
    try:
        print ("executing: ")
        print (cmd)
        os.system(cmd)
    except Exception as e:
        print("Fail to call " + clang_format_bin + " with error:")
        print(e)


if __name__ == "__main__":
    """ Format source files given or found recursively in the given folders """

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('files_or_folders', metavar='files_or_folders',
                        type=str, nargs='+',
                        help='List of source files or folders.')
    args = parser.parse_args()

    clang_format_bin = find_clang_format(['clang-format', 'clang-format-6.0',
                                          'clang-format-8'])
    clang_format_config = load_clang_format_config()
    list_of_files = list_of_files_to_format(args.files_or_folders)

    if not list_of_files:
        raise RuntimeError(
            "No file to format, please indicate paths to files or directories.")

    execute_clang_format(clang_format_bin, clang_format_config, list_of_files)
