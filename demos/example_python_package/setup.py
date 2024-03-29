"""setup.py

License BSD-3-Clause
Copyright (c) 2021, New York University and Max Planck Gesellschaft.

This a very simple example on how you could build the documentation of your
package if you have the mpi_cmake_modules installed.
"""

from pathlib import Path
from setuptools import setup
from setuptools.command.build_py import build_py


# Defines the paramters of this package:
THIS_PACKAGE_NAME = "example_python_package"
THIS_PACKAGE_PYTHON_MODULES = ["example_python_package"]
THIS_PACKAGE_VERSION = "1.0"


class custom_build_py(build_py):
    def run(self):

        # Try to build the doc and install it.
        try:
            # Get the mpi_cmake_module build doc method
            from breathing_cat.build import (
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
    cmdclass={"build_py": custom_build_py},
)
