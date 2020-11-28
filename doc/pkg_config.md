PKG Config
==========

## Introduction

This CMake module is based on the
[pkg-config](https://linux.die.net/man/1/pkg-config) module.

This tool is done for finding dependencies using a cross platform and
efficient tool. PKG-config is based on `.pc` files containing the dependencies
informations. For PKG-config to work one need to properly setup the
`PKG_CONFIG_PATH` to the path of the `.pc` files locations. Typically
`lib/pkgconfig` in the install folders.

## Usage

### Basic usage

The basic usage of this is like the following:

    # Look for the dependency
    ADD_OPTIONAL_DEPENDENCY(<dependency name 1>)
    ADD_REQUIRED_DEPENDENCY(<dependency name 2>)

    # Use the dependency on a CMake target:
    PKG_CONFIG_USE_DEPENDENCY(target <dependency name 1>)
    PKG_CONFIG_USE_DEPENDENCY(target <dependency name 2>)
