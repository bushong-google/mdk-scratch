#!/bin/bash

# Find our virtual environment's Python interpreter.
here=$(cd $(dirname $0) ; echo $PWD)
python=$here/.venv/bin/python

# Run our model script.
$python -m model
