"""Generate a skeleton of template files to implement various ML Ops processes."""

import os
import pathlib
import shutil

LINE_WIDTH = 80


def init(overwrite: bool):
    """Generate a skeleton of template files to implement various ML Ops processes."""

    # Find our templates:
    template_dir = (pathlib.Path(__file__).parent / ".." / "templates").resolve()

    # Walk through all the files in the templates dir:
    for dirpath, _, filenames in os.walk(template_dir):
        for filename in filenames:
            src = pathlib.Path(dirpath) / filename
            dest = "." / src.relative_to(template_dir)

            # If the destination file already exists, and the overwite flag is
            #   False, then skip it.
            if (dest.exists()) and (not overwrite):
                _printStatus(dest, " exists! [SKIPPED]")

            # Otherwise, if the file does not already exist, copy it over:
            else:
                # If the destination subdirectory does not exist, create it.
                destDir = dest.parent
                if not destDir.exists():
                    os.makedirs(destDir)
                    print(f"Creating: {destDir}")

                # Copy the file and print a status message.
                shutil.copyfile(src, dest)
                _printStatus(dest, "[CREATED]")


def _printStatus(
    dest: pathlib.Path,
    msg: str,
):
    """Print a status message to the terminal."""
    width = LINE_WIDTH - len(str(dest))
    print(f"{dest!s}{msg:>{width}}")
