"""Deletes the skeleton that is created via `mdk init`.  (This is dangerous, and
it is really only useful for developers of the mdk package.)
"""

import os
import pathlib

LINE_WIDTH = 80


def destroy(force: bool):
    """Delete the files that were created in cli.init.init()."""

    # First ask the user if they're sure they want to destroy all the files.
    if not force:
        if (
            input(
                "This will delete many files and cannot be undone.  Are you sure?"
                " (y/N) "
            )
            != "y"
        ):
            return

    # Find our templates:
    template_dir = (pathlib.Path(__file__).parent / ".." / "templates").resolve()

    # Walk through all the files in the templates dir, to delete them:
    dirparts = set()
    for dirpath, _, filenames in os.walk(template_dir):
        for filename in filenames:
            src = pathlib.Path(dirpath) / filename
            dest = "." / src.relative_to(template_dir)

            # If the destination file exists, delete it.
            if dest.exists():
                dest.unlink()
                _printStatus(dest, "[DELETED]")

            dirparts.add(dest.parts[:-1])

    # Now delete the directories.
    # Sort the paths by length, so that we go through this depth first.  (We
    #   want to delete subdirectories before parent directories.)
    dirparts = sorted(dirparts, key=lambda x: -len(x))
    for dirpart in dirparts:
        dir = pathlib.Path("/".join(dirpart))
        # If the directory exists and is not the root directory, and the
        #   directory is empty, delete the directory.
        if (dir.is_dir()) and (dir != ".") and (not os.listdir(dir)):
            dir.rmdir()
            _printStatus(str(dir) + "/", "[DELETED]")


def _printStatus(
    dest: pathlib.Path | str,
    msg: str,
):
    """Print a status message to the terminal."""
    width = LINE_WIDTH - len(str(dest))
    print(f"{dest!s}{msg:>{width}}")
