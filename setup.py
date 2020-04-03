"""@package setup
This file defines the python modules in this package.

@file
@license License BSD-3-Clause
@copyright Copyright (c) 2020, New York University and Max Planck Gesellschaft.
"""

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

## Fetch values from package.xml
setup_args = generate_distutils_setup(
    packages=['mpi_cmake_modules'],
    package_dir={'': 'python'},
    include_package_data=True,
    package_data={"":["*_clang-format"]},
)

setup(**setup_args)
