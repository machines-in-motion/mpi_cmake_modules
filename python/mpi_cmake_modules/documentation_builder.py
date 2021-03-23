"""documentation_builder.py

Build the documentation based on sphinx and the read_the_doc layout.

License BSD-3-Clause
Copyright (c) 2021, New York University and Max Planck Gesellschaft.
"""

import subprocess
import shutil
from pathlib import Path
import mpi_cmake_modules
from mpi_cmake_modules.utils import which


def _find_doxygen():
    """Find the full path to the doxygen executable.

    Raises:
        Exception: if the doxygen executable is not found.

    Returns:
        The full path to the doxygen executable.
    """
    exec_path = which("doxygen")
    if exec_path is not None:
        return exec_path
    raise Exception(
        "doxygen executable not found. You may try "
        "'(sudo ) apt install doxygen*'"
    )


def _find_breathe_apidoc():
    """Find the full path to the breathe-apidoc executable.

    Raises:
        Exception: if the breathe-apidoc executable is not found.

    Returns:
        The full path to the black executable.
    """
    exec_path = which("breathe-apidoc")
    if exec_path is not None:
        return exec_path
    raise Exception(
        "breathe-apidoc executable not found. You may try "
        "'(sudo -H) pip3 install breathe'"
    )


def _find_sphinx_apidoc():
    """Find the full path to the sphinx-apidoc executable.

    Raises:
        Exception: if the sphinx-apidoc executable is not found.

    Returns:
        The full path to the black executable.
    """
    exec_path = which("sphinx-apidoc")
    if exec_path is not None:
        return exec_path
    raise Exception(
        "sphinx-apidoc executable not found. You may try "
        "'(sudo -H) pip3 install sphinx'"
    )


def _find_sphinx_build():
    """Find the full path to the sphinx-build executable.

    Raises:
        Exception: if the sphinx-build executable is not found.

    Returns:
        The full path to the black executable.
    """
    exec_path = which("sphinx-build")
    if exec_path is not None:
        return exec_path
    raise Exception(
        "sphinx-build executable not found. You may try "
        "'(sudo -H) pip3 install sphinx'"
    )


def _resource_path(project_source_dir):
    """
    Fetch the resources path. This will contains all the configuration files
    for the different executables: Doxyfile, conf.py, etc.

    Args:
        project_source_dir (str): Path to the source file of the project.

    Raises:
        Exception: if the resources folder is not found.

    Returns:
        str: Path to the configuration files.
    """
    assert Path(project_source_dir).is_dir()

    # Find the resources from the package.
    project_name = Path(project_source_dir).stem
    if project_name == "mpi_cmake_modules":
        resource_path = Path(project_source_dir) / "resources"
        if not resource_path.is_dir():
            raise Exception(
                "failed to find the resource directory in "
                + str(mpi_cmake_modules.__path__)
            )
        return resource_path

    # Find the resources from the installation of this package.
    for module_path in mpi_cmake_modules.__path__:
        resource_path = Path(module_path) / "resources"
        if resource_path.is_dir():
            return resource_path
    raise Exception(
        "failed to find the resource directory in "
        + str(mpi_cmake_modules.__path__)
    )


def _build_doxygen_xml(doc_build_dir, project_source_dir):
    """
    Use doxygen to parse the C++ source files and generate a corresponding xml
    entry.

    Args:
        doc_build_dir (str): Path to where the doc should be built
        project_source_dir (str): Path to the source file of the project.
    """
    # Get project_name
    project_name = Path(project_source_dir).stem

    # Get the doxygen executable.
    doxygen = _find_doxygen()

    # Get the resources path.
    resource_path = _resource_path(project_source_dir)

    # get the Doxyfile.in file
    doxyfile_in = resource_path / "sphinx" / "doxygen" / "Doxyfile.in"
    assert doxyfile_in.is_file()

    # Which files are going to be parsed.
    doxygen_file_patterns = "*.h *.hpp *.hh *.cpp *.c *.cc *.hxx"

    # Where to put the doxygen output.
    doxygen_output = Path(doc_build_dir) / "doxygen"

    # Parse the Doxyfile.in and replace the value between '@'
    with open(doxyfile_in, "rt") as f:
        doxyfile_out_text = (
            f.read()
            .replace("@PROJECT_NAME@", project_name)
            .replace("@PROJECT_SOURCE_DIR@", project_source_dir)
            .replace("@DOXYGEN_FILE_PATTERNS@", doxygen_file_patterns)
            .replace("@DOXYGEN_OUTPUT@", str(doxygen_output))
        )
    doxyfile_out = Path(doxygen_output) / "Doxyfile"
    doxyfile_out.parent.mkdir(parents=True, exist_ok=True)
    with open(str(doxyfile_out), "wt") as f:
        f.write(doxyfile_out_text)

    bashCommand = doxygen + " " + str(doxyfile_out)
    process = subprocess.Popen(
        bashCommand.split(), stdout=subprocess.PIPE, cwd=str(doxygen_output)
    )
    output, error = process.communicate()
    print("Doxygen output:\n", output.decode("UTF-8"))
    print("Doxygen error:\n", error)
    print("")


def _build_breath_api_doc(doc_build_dir):
    """
    Use breathe_apidoc to parse the xml output from Doxygen and generate
    '.rst' files.

    Args:
        doc_build_dir (str): Path where to create the temporary output.
    """
    breathe_apidoc = _find_breathe_apidoc()
    breathe_input = Path(doc_build_dir) / "doxygen" / "xml"
    breathe_output = Path(doc_build_dir) / "breathe_apidoc"
    breathe_option = "-f -g class,interface,struct,union,file,namespace,group"

    bashCommand = (
        breathe_apidoc
        + " -o "
        + str(breathe_output)
        + " "
        + str(breathe_input)
        + " "
        + str(breathe_option)
    )
    process = subprocess.Popen(
        bashCommand.split(), stdout=subprocess.PIPE, cwd=str(doc_build_dir)
    )
    output, error = process.communicate()
    print("breathe-apidoc output:\n", output.decode("UTF-8"))
    print("breathe-apidoc error:\n", error)
    print("")


def _build_sphinx_api_doc(doc_build_dir, project_source_dir):
    """
    Use sphinx_apidoc to parse the python files output from Doxygen and
    generate '.rst' files.

    Args:
        doc_build_dir (str): Path where to create the temporary output.
        project_source_dir (str): Path to the source file of the project.
    """
    # define input folder
    project_name = Path(project_source_dir).stem
    python_folder = Path(project_source_dir) / "python" / project_name
    src_folder = Path(project_source_dir) / "src" / project_name

    sphinx_apidoc = _find_sphinx_apidoc()
    sphinx_apidoc_output = str(doc_build_dir)
    if python_folder.is_dir():
        sphinx_apidoc_input = str(python_folder)
        bashCommand = (
            sphinx_apidoc
            + " -o "
            + str(sphinx_apidoc_output)
            + " "
            + str(sphinx_apidoc_input)
        )
        process = subprocess.Popen(
            bashCommand.split(), stdout=subprocess.PIPE, cwd=str(doc_build_dir)
        )
        output, error = process.communicate()
        print("sphinx-apidoc output:\n", output.decode("UTF-8"))
        print("sphinx-apidoc error:\n", error)

    elif src_folder.is_dir():
        sphinx_apidoc_input = str(src_folder)
        bashCommand = (
            sphinx_apidoc
            + "-f -o "
            + str(sphinx_apidoc_output)
            + " "
            + str(sphinx_apidoc_input)
        )
        process = subprocess.Popen(
            bashCommand.split(), stdout=subprocess.PIPE, cwd=str(doc_build_dir)
        )
        output, error = process.communicate()
        print("sphinx-apidoc output:\n", output.decode("UTF-8"))
        print("sphinx-apidoc error:\n", error)

    else:
        print("No python module for sphinx-apidoc to parse.")
    print("")


def _build_sphinx_build(doc_build_dir):
    """
    Use sphinx_build to parse the cmake and rst files previously generated and
    generate the final html layout.

    Args:
        doc_build_dir (str): Path where to create the temporary output.
    """
    sphinx_build = _find_sphinx_build()
    bashCommand = (
        sphinx_build
        + " -M html "
        + str(doc_build_dir)
        + " "
        + str(doc_build_dir)
    )
    process = subprocess.Popen(
        bashCommand.split(), stdout=subprocess.PIPE, cwd=str(doc_build_dir)
    )
    output, error = process.communicate()
    print("sphinx-apidoc output:\n", output.decode("UTF-8"))
    print("sphinx-apidoc error:\n", error)


def _search_for_cpp_api(doc_build_dir, project_source_dir, resource_dir):
    """Search if there is a C++ api do document, and document it.

    Args:
        doc_build_dir (str): Path where to create the temporary output.
        project_source_dir (str): Path to the source file of the project.
        resource_dir (str): Path to the resources files for the build.

    Returns:
        str: String added to the main index.rst in case there is a C++ api.
    """
    cpp_api = ""

    # Search for C++ API:
    cpp_files = [
        p.resolve()
        for p in Path(project_source_dir).glob("**/*")
        if p.suffix in [".c", ".cc", ".cpp", ".hxx", ".h"]
    ]
    if cpp_files:
        # Introduce this toc tree in the main index.rst
        cpp_api = (
            "C++ API\n"
            "-------\n\n"
            ".. toctree::\n"
            "   :maxdepth: 2\n\n"
            "   doxygen_index\n\n"
        )
        # Copy the index of the C++ API.
        shutil.copy(
            str(
                resource_dir
                / "sphinx"
                / "sphinx"
                / "doxygen_index_one_page.rst.in"
            ),
            str(doc_build_dir / "doxygen_index_one_page.rst"),
        )
        shutil.copy(
            str(resource_dir / "sphinx" / "sphinx" / "doxygen_index.rst.in"),
            str(doc_build_dir / "doxygen_index.rst"),
        )

        # Build the doxygen xml files.
        _build_doxygen_xml(doc_build_dir, project_source_dir)
        # Generate the .rst corresponding to the doxygen xml
        _build_breath_api_doc(doc_build_dir)

    return cpp_api


def _search_for_python_api(doc_build_dir, project_source_dir):
    """Search for a Python API and build it's documentation.

    Args:
        doc_build_dir (str): Path where to create the temporary output.
        project_source_dir (str): Path to the source file of the project.

    Returns:
        str: String added to the main index.rst in case there is a Python api.
    """
    python_api = ""

    # Get the project name form the source path.
    project_name = Path(project_source_dir).stem

    # Search for Python API.
    if (
        Path(project_source_dir) / "python" / project_name / "__init__.py"
    ).is_file() or (
        Path(project_source_dir) / "src" / project_name / "__init__.py"
    ).is_file():
        # Introduce this toc tree in the main index.rst
        python_api = (
            "Python API\n"
            "----------\n\n"
            "* :ref:`modindex`\n\n"
            ".. toctree::\n"
            "   :maxdepth: 3\n\n"
            "   modules\n\n"
        )
        _build_sphinx_api_doc(doc_build_dir, project_source_dir)
    return python_api


def _search_for_cmake_api(doc_build_dir, project_source_dir, resource_dir):
    cmake_api = ""

    # Search for CMake API.
    cmake_files = [
        p.resolve()
        for p in Path(project_source_dir).glob("cmake/*")
        if p.suffix in [".cmake"] or p.name == "CMakeLists.txt"
    ]
    if cmake_files:
        # Introduce this toc tree in the main index.rst
        cmake_api = (
            "CMake API\n"
            "---------\n"
            ".. toctree::\n"
            "   :maxdepth: 3\n\n"
            "   cmake_doc\n\n"
        )
        doc_cmake_module = ""
        for cmake_file in cmake_files:
            doc_cmake_module += cmake_file.stem + "\n"
            doc_cmake_module += len(cmake_file.stem) * "-" + "\n\n"
            doc_cmake_module += (
                ".. cmake-module:: cmake/" + cmake_file.name + "\n\n"
            )
        with open(
            str(resource_dir / "sphinx" / "sphinx" / "cmake_doc.rst.in"), "rt"
        ) as f:
            out_text = f.read().replace("@DOC_CMAKE_MODULE@", doc_cmake_module)
        with open(str(doc_build_dir / "cmake_doc.rst"), "wt") as f:
            f.write(out_text)

        shutil.copytree(
            str(Path(project_source_dir) / "cmake"),
            str(doc_build_dir / "cmake"),
        )

    return cmake_api


def _search_for_general_documentation(
    doc_build_dir, project_source_dir, resource_dir
):
    general_documentation = ""
    # Search for additional doc.
    if (Path(project_source_dir) / "doc").is_dir():
        general_documentation = (
            "General Documentation\n---------------------\n"
            ".. toctree::\n"
            "   :maxdepth: 2\n\n"
            "   general_documentation\n\n"
        )
        shutil.copy(
            resource_dir
            / "sphinx"
            / "sphinx"
            / "general_documentation.rst.in",
            str(doc_build_dir / "general_documentation.rst"),
        )
    return general_documentation


def build_documentation(build_dir, project_source_dir, project_version):

    #
    # Initialize the paths
    #

    # Get the project name form the source path.
    project_name = Path(project_source_dir).stem

    # Get the build folder for the documentation.
    doc_build_dir = (
        Path(build_dir) / "share" / project_name / "docs" / "sphinx"
    )

    # Create the folder architecture inside the build folder.
    shutil.rmtree(str(doc_build_dir), ignore_errors=True)
    doc_build_dir.mkdir(parents=True, exist_ok=True)

    # Get the path to resource files.
    resource_dir = Path(_resource_path(project_source_dir))

    #
    # Parametrize the final doc layout depending we have CMake/Python/C++ api.
    #

    # String to replace in the main index.rst

    cpp_api = _search_for_cpp_api(
        doc_build_dir, project_source_dir, resource_dir
    )

    python_api = _search_for_python_api(doc_build_dir, project_source_dir)

    cmake_api = _search_for_cmake_api(
        doc_build_dir, project_source_dir, resource_dir
    )

    general_documentation = _search_for_general_documentation(
        doc_build_dir, project_source_dir, resource_dir
    )

    #
    # Configure the config.py and the index.rst.
    #

    # configure the index.rst.in.
    header = "Welcome to " + project_name + "'s documentation!"
    header += "\n" + len(header) * "=" + "\n"
    with open(
        str(resource_dir / "sphinx" / "sphinx" / "index.rst.in"), "rt"
    ) as f:
        out_text = (
            f.read()
            .replace("@HEADER@", header)
            .replace("@GENERAL_DOCUMENTATION@", general_documentation)
            .replace("@CPP_API@", cpp_api)
            .replace("@PYTHON_API@", python_api)
            .replace("@CMAKE_API@", cmake_api)
        )
    with open(str(doc_build_dir / "index.rst"), "wt") as f:
        f.write(out_text)

    # configure the config.py.in.
    with open(
        str(resource_dir / "sphinx" / "sphinx" / "conf.py.in"), "rt"
    ) as f:
        out_text = (
            f.read()
            .replace("@PROJECT_SOURCE_DIR@", project_source_dir)
            .replace("@PROJECT_NAME@", project_name)
            .replace("@PROJECT_VERSION@", project_version)
            .replace(
                "@DOXYGEN_XML_OUTPUT@", str(doc_build_dir / "doxygen" / "xml")
            )
        )
    with open(str(doc_build_dir / "conf.py"), "wt") as f:
        f.write(out_text)

    #
    # Copy the license and readme file.
    #
    readme = [
        p.resolve()
        for p in Path(project_source_dir).glob("*")
        if p.suffix in [".md"] and p.name.lower() == "readme.md"
    ][0]
    shutil.copy(str(readme), doc_build_dir / "readme.md")

    license_file = [
        p.resolve()
        for p in Path(project_source_dir).glob("*")
        if p.name in ["LICENSE", "license.txt"]
    ][0]
    shutil.copy(str(license_file), doc_build_dir / "license.txt")

    #
    # Generate the html doc
    #
    _build_sphinx_build(doc_build_dir)
