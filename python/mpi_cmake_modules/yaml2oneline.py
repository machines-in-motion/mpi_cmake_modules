#!/usr/bin/env python3
"""Read a YAML-file and output its content as a one-line string
@file
@license License BSD-3-Clause
@copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.

Example:  A YAML file with the content

    foo: 13
    bar: 42

would be converted into

    {foo: 13, bar: 42}

"""
import sys
import yaml


def yaml2oneline(filename):
    with open(filename, "r") as fh:
        data = yaml.load(fh, Loader=yaml.SafeLoader)
        return yaml.dump(data, default_flow_style=True).replace("\n", "")


if __name__ == "__main__":
    filename = sys.argv[1]
    print(yaml2oneline(filename))
