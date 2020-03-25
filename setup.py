"""@package mpi_cmake_modules

@file
@license License BSD-3-Clause
@copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
@date 2019-05-22

@brief This file defines the python modules in this package.

"""

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

# fetch values from package.xml
setup_args = generate_distutils_setup(
    packages=['mpi_cmake_modules'],
    package_dir={'': 'python'},
)

setup(**setup_args)
