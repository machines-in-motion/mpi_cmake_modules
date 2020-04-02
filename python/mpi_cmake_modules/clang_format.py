#!/usr/bin/env python
""" @namespace mpi_cmake_modules.clang_format
Execute a clang-format on a desired file or folder.

Usage example:
- @code rosrun mpi_cmake_module clang_format /path/to/format @endcode
- @code rosrun mpi_cmake_module clang_format file_to_format.ext @endcode

@file
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
import mpi_cmake_modules
from mpi_cmake_modules.yaml2oneline import yaml2oneline


def find_clang_format(name_list=['clang-format']):
    """ Find the full path to the clang-format executable.
    
    Look by default for the `clang-format` executable in the PATH environment
    variable.

    Args:
        name_list: list(str) `--` Potential executable names which might differ
        according to the clang-format version availbale.
    
    Returns:
        The full path to the clang-format executable.
    """
    for name in name_list:
        path_to_clang_format = which(name)
        if path_to_clang_format is not None:
            return path_to_clang_format
    raise Exception("clang-format executable not found. You may try "
                    "'sudo apt-get install clang-format'")


def load_clang_format_config():
    """ Look for the clang-formt paramter file in this package.
    
    Look for the _clang-format file located in this package and convert it
    in a one line dictionnary string.

    Returns:
        The _clang-format in a online dictionnary string.
    """
    for module_path in mpi_cmake_modules.__path__:
        for (dirpath, _, filenames) in walk(module_path):
            if "_clang-format" in filenames:
                return yaml2oneline(path.join(dirpath, "_clang-format"))
            break


def test_valid_file(filename):
    """ Test if the input file is a valid C/C++ file.
    
    Look at the extension of the file and return if it is a good one or not.

    Args:
        filename: str `--` Path to the file to test.
    
    Returns:
        True if the file ends with one of the following extension
            (".h", ".c", ".hh", ".cc", ".hpp", ".cpp", ".hxx", ".cxx")
        False otherwise.
    """
    if (path.isfile(filename) and any([filename.endswith(suffix) for suffix in
                                       (".h", ".c", ".hh", ".cc", ".hpp",
                                        ".cpp", ".hxx", ".cxx")])):
        return True
    else:
        return False


# either returns file_or_directory as such (if exists)
# or assumes file_or_directory was a relative path and returns
# the corresponding absolute path (if exist, None otherwise)
def _get_full_path(file_or_directory):
    if path.isfile(file_or_directory) or path.isdir(file_or_directory):
        return file_or_directory
    fixed_path = os.path.abspath(os.getcwd()+os.sep+file_or_directory)
    if os.isfile(fixed_path) or os.dir(fixed_path):
        return fixed_path
    return None
        
    
def list_of_files_to_format(files_or_directories):
    """ Get the list of files to format exploring the input arguments.
    
    Explore recursively the directories given in the input list and create
    a list of all files. Add to this list the files given in the input list.
    Sort out the files that are source-files or not and return the list
    of source files.

    Args:
        files_or_directories: list(str) `--` List of files or directories.
    
    Returns:
        True if the file ends with one of the following extension
            (".h", ".c", ".hh", ".cc", ".hpp", ".cpp", ".hxx", ".cxx")
        False otherwise.
    """
    fixed = [_get_full_path(fod)
             for fod in files_or_directories]
    for original,fix in zip(files_or_directories,fixed):
        if fix is None:
            raise Exception("failed to find: "+str(original))
    files_or_directories = fixed
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
    """ Execute the formatting of C/C++ files using clang-format.
    
    Get the path to the executable, and run it using the clang-format insput
    paramter on the list of files to format.

    Args:
        clang_format_bin: list(str) `--` Path to the clang-format binary.
        clang_format_config: list(str) `--` One line dictionnary string
            containing the clang-format parameters.
        clang_format_arg: list(str) `--` List of source files to parse.   
    """

    cmd = ' '.join([clang_format_bin,
                    ' -style="' + clang_format_config + '"',
                    ' -i ' + ' '.join(clang_format_arg)
                    ])
    try:
        print ("\nexecuting: ")
        print (cmd)
        print ("")
        os.system(cmd)
    except Exception as e:
        print("Fail to call " + clang_format_bin + " with error:")
        print(e)


if __name__ == "__main__":
    """ Format source files given or found recursively in the given folders """

    ## Parser for the input arguments
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('files_or_folders', 
                        ## Store the argument in files_or_folders.
                        metavar='files_or_folders',
                        ## Define the input argument type.
                        type=str,
                        ## ...
                        nargs='+',
                        ## Help string in case the argument is wrong.
                        help='List of source files or folders.')
    ## Input arguments.
    args = parser.parse_args()
    ## Path to the clang-format binary.
    clang_format_bin = find_clang_format(['clang-format', 'clang-format-6.0',
                                          'clang-format-8'])
    ## clang-format parameters.
    clang_format_config = load_clang_format_config()
    ## List of files or directories to parse.
    list_of_files = list_of_files_to_format(args.files_or_folders)

    if not list_of_files:
        raise RuntimeError(
            "\nNo file to format, please indicate paths to files or directories.\n")
    else :
        print ("\nformatting:")
        for f in list_of_files:
            print ("\t"+str(f))
        print ("")
            
    execute_clang_format(clang_format_bin, clang_format_config, list_of_files)
