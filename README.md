# MLOps Dev Kit (MDK)

(This is currently a stub README.)

The following will create and activate a virtual environment and then
build a wheel file:

```
$ uv sync
$ source ./venv/bin/activate
$ ./configure
$ make
```

## Example Invocation

```
# Create and activate a virtual environment:
$ uv sync
$ source .venv/bin/activate

# Install the mdk package in editable mode, so that mdk is in your path:
$ uv pip install ../..

# Run mdk init:
$ cd examples/dry-beans-v1
$ mdk init
```
