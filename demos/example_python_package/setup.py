"""setup.py

License BSD-3-Clause
Copyright (c) 2021, New York University and Max Planck Gesellschaft.

This a very simple example on how you could build the documentation of your
package if you have the mpi_cmake_modules installed.
"""

import sys
from shutil import copytree, rmtree
from pathlib import Path
from distutils.core import setup
from distutils.command.build_py import build_py
from setuptools.command.install import install
from setuptools.command.develop import develop
from setuptools.command.egg_info import egg_info


# Defines the paramters of this package:
THIS_PACKAGE_NAME = "example_python_package"
THIS_PACKAGE_PYTHON_MODULES = ["example_python_package"]
THIS_PACKAGE_VERSION = "1.0"


def _get_build_dir():
    """get where the build dir is:

    Returns:
        str: Path to the build directory
    """
    build_folder = "build"

    if "--build-base" in sys.argv:
        index = sys.argv.index("--build-base")
    elif "-b" in sys.argv:
        index = sys.argv.index("-b")
    else:
        index = None
    if index is not None:
        if index + 1 < len(sys.argv):
            build_folder = sys.argv[index + 1]

    return Path(build_folder)


def _get_install_dir():
    """get where the build dir is:

    Returns:
        str: Path to the install directory
    """
    install_folder = "install"

    if "--prefix" in sys.argv:
        index = sys.argv.index("--build-base")
    else:
        index = None
    if index is not None:
        if index + 1 < len(sys.argv):
            install_folder = sys.argv[index + 1]

    return Path(install_folder)


def _print_error(*args, **kwargs):
    """ Print in stderr. """
    print(*args, file=sys.stderr, **kwargs)


def _custom_install(install_object):
    """
    Build the doc in build_folder/doc/html
    Install the doc in install_folder/share/<project_name>/dos/sphinx/html.
    """

    # destination = (
    #     Path(_get_install_dir())
    #     / "share"
    #     / THIS_PACKAGE_NAME
    #     / "docs"
    #     / "sphinx"
    #     / "html"
    # )
    # source = Path("doc") / "html"
    # # clean the install tree
    # rmtree("share", ignore_errors=True)
    # destination.mkdir(parents=True, exist_ok=True)
    # copytree(source, destination)
    pass


class custom_build_py(build_py):
    def run(self):

        # Try to build the doc and install it.
        try:
            # Get the mpi_cmake_module build doc method
            from mpi_cmake_modules.documentation_builder import (
                build_documentation,
            )

            build_documentation(
                str(
                    (
                        Path(self.build_lib) / THIS_PACKAGE_NAME / "doc"
                    ).absolute()
                ),
                str(Path(__file__).parent.absolute()),
                THIS_PACKAGE_VERSION,
            )
        except ImportError as e:
            print(e)

        # distutils uses old-style classes, so no super()
        build_py.run(self)


class custom_install(install):
    def run(self):
        install.run(self)
        _custom_install(self)


class custom_develop(develop):
    def run(self):
        develop.run(self)
        _custom_install(self)


class custom_egg_info(egg_info):
    def run(self):
        egg_info.run(self)
        _custom_install(self)


# Setup this package.
setup(
    # Standard metadata.
    name=THIS_PACKAGE_NAME,
    version=THIS_PACKAGE_VERSION,
    py_modules=THIS_PACKAGE_PYTHON_MODULES,
    # Install the package from the src folder.
    package_dir={
        THIS_PACKAGE_NAME: str(
            Path(__file__).parent.absolute() / "src" / THIS_PACKAGE_NAME
        )
    },
    packages=[THIS_PACKAGE_NAME],
    # Here we call the above class upon build.
    cmdclass={
        "build_py": custom_build_py,
        "install": custom_install,
        "develop": custom_develop,
        "egg_info": custom_egg_info,
    },
)
