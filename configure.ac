#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.72])
AC_INIT([mdk], [0.1])

# Checks for programs.
AC_ARG_VAR(PYTHON, [Python interpreter])
AC_CHECK_PROGS(PYTHON,python,false)
AS_IF([test x"$PYTHON" == x"false"],
      [AC_MSG_ERROR([Python interpreter not found])])

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
