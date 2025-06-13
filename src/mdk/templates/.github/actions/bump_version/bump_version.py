import argparse
import toml
import os
from enum import StrEnum


class ReleaseType(StrEnum):
    MAJOR = "major"
    MINOR = "minor"
    PATCH = "patch"


def bump_version(version: str, release_type: ReleaseType) -> str:
    """
    Bump the version based on the version type
    """
    major, minor, patch = version.split(".")
    if release_type == ReleaseType.MAJOR:
        major = str(int(major) + 1)
        minor = "0"
        patch = "0"
    elif release_type == ReleaseType.MINOR:
        minor = str(int(minor) + 1)
        patch = "0"
    elif release_type == ReleaseType.PATCH:
        patch = str(int(patch) + 1)
    return f"{major}.{minor}.{patch}"


def main(service_name: str, release_type: ReleaseType) -> None:
    file_path = f"{service_name}/pyproject.toml"
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Error: {file_path} does not exist!")
    with open(file_path, "r") as f:
        data = toml.load(f)
    if "project" not in data or "version" not in data["project"]:
        raise KeyError(f"Error: No 'version' key found in {file_path}")
    version = data["project"]["version"]
    new_version = bump_version(version, release_type)
    data["project"]["version"] = new_version
    with open(file_path, "w") as f:
        toml.dump(data, f)
    print(f"Successfully bumped {service_name} to version {new_version}")


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "service_name",
        type=str,
        help="The name of the service to bump the version for",
    )
    arg_parser.add_argument(
        "release_type",
        type=str,
        choices=list(ReleaseType),
        help="The type of version to bump",
    )
    args = arg_parser.parse_args()
    main(
        service_name=args.service_name,
        release_type=ReleaseType(args.release_type),
    )
