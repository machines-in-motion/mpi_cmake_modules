Python
======

## Introduction

This part is very important as it provides tools to search for the Python
libraries and includes depending on the required Python version.
Plus some tools to create python bindings using pybind11.

## Usage

### Search for Python

The simplest thing is here to find the default Python library:

    find_package(Python REQUIRED)

This macros is influenced by `PYTHON_EXECUTABLE` and `PYTHON_LIBRARY` which can
be set for Python2 via the command:

    colcon build --cmake-args -DPYTHON_EXECUTABLE=`which python2`

you can add `-DPYTHON_LIBRARY=`/usr/lib/x86_64-linux-gnu/libpython2.7.so``
if needed

or for Python3 via the command:

    colcon build --cmake-args -DPYTHON_EXECUTABLE=`which python3`

you can add `-DPYTHON_LIBRARY=`/usr/lib/x86_64-linux-gnu/libpython3.5m.so``
if needed

Please make sure the library exists at the defined place before executing the
above commands.

If you only want to find the python executable you can just do:

    get_python_interpreter(my_var)

`my_var` will contain the path to the python interpreter.

### Install path

In order to install files and library in the good place for python to find it
on need to get the correct path:

    get_python_install_dir(my_var)

`my_var` contains the path to where the python files needs to be installed.
