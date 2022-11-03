# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).


## [Unreleased]
### Changed
- `mpi_doc_build` uses
  [breathing-cat](https://github.com/machines-in-motion/breathing-cat)
  internally and is marked as deprecated.
- The `add_documentation` cmake macro now uses breathing-cat internally. The
  `DOXYGEN_EXCLUDE_PATTERNS` argument of `add_documentation` is not supported
  anymore, use a breathing-cat config file instead.  Apart from this,
  `add_documentation` should mostly work the same way as before.

### Removed
- Python documentation build (it has been moved to its own package called
  [breathing-cat](https://github.com/machines-in-motion/breathing-cat).


## [2.0.0] - 2022-06-29
### Added
- Python API for generating documentation.
- Documentation build: Support for README.rst (if README.md does not exist).
- Added `FindZeroMQ.cmake` and `FindZeroMQPP.cmake`.
- Added `run-clang-format` for easier usage of `clang-format`.
- Add optional argument `DOXYGEN_EXCLUDE_PATTERNS` to `add_documentation()`
  which allows excluding some files from the documentation.

### Changed
- clang-format config: Preserve include blocks.
- Replace `mpi_cpp_format` with an alias for `run-clang-format` (same and more
  functionality but the arguments changed a bit).
- Documentation build: Use Python package at install location (needed for
  packages with pybind11 modules).
- Improved the Python documentation builder (#44).
- OS Detection: Use real-time build when the "lowlatency" kernel is detected.

### Fixed
- CMake: Installation of DG modules.
- CMake: Fixed problems with finding Python.
- Documentation build: Issue with navigation bar.


## [1.0.0] - 2021-02-03

There is no changelog for this or earlier versions.


[Unreleased]: https://github.com/machines-in-motion/real_time_tools/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/machines-in-motion/real_time_tools/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/machines-in-motion/real_time_tools/releases/tag/v1.0.0
