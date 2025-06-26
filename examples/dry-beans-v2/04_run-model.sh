#!/bin/bash

# Bail out of a virtual env if we're in one.
deactivate 2> /dev/null

# Create a virtual environment, if it doesn't exist.
uv sync || exit $?

# Find our virtual environment's Python interpreter.
here=$(cd $(dirname $0) ; echo $PWD)
python=$here/.venv/bin/python

# Run our model script.
$python -m model
