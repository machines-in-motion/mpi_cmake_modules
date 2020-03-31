#!/usr/bin/env python

## @namespace mpi_cmake_modules.yaml2oneline
""" Convert a YAML file in a one line string

For example, a YAML file with the content:
@code
    foo: 13
    bar: 42
@endcode
would be converted into: @code "{foo: 13, bar: 42}" @endcode

@file yaml2oneline.py
@license License BSD-3-Clause
@copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
"""

import sys
import yaml


def yaml2oneline(filename):
    """ Convert a yaml file into a dictionnary one-line string
    
    This function is used here typically in order to parse the yaml config file
    defining the clang-format parameters.

    Args:
        filename: str `--` Path relative to the execution path or global path.
    """
    with open(filename, "r") as fh:
        data = yaml.load(fh, Loader=yaml.SafeLoader)
        return yaml.dump(data, default_flow_style=True).replace("\n", "")


if __name__ == "__main__":
    """ Execute yaml2oneline on the input yaml file. """

    ## input yaml file name
    filename = sys.argv[1]
    print(yaml2oneline(filename))
