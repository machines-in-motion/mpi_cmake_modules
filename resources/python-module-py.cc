/**
 * @file python-module-py.cc
 * @author Maximilien Naveau (maximilien.naveau@gmail.com)
 * @license License BSD-3-Clause
 * @copyright Copyright (c) 2019, New York University and Max Planck Gesellshaft.
 * @date 2019-05-22
 * 
 * @brief This file is copied/inspired from
 * https://github.com/jrl-umi3218/jrl-cmakemodules/blob/master/dynamic_graph/python-module-py.cc
 */

#include <Python.h>


/**
   \brief List of python functions
*/
static PyMethodDef functions[] = {
  {NULL, NULL, 0, NULL}        /* Sentinel */
};

PyMODINIT_FUNC
initwrap(void)
{
    PyObject *m;

    m = Py_InitModule("wrap", functions);
    if (m == NULL)
        return;
}
