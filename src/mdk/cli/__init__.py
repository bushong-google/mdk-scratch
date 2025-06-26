# This allows import mdk.cli to give you mdk.cli.init and mdk.cli.run.

from mdk.cli import destroy, init, run

__all__ = [
    "destroy",
    "init",
    "run",
]
