#!/bin/bash

set -e

# Ensure Git is available
if ! command -v git &> /dev/null; then
  echo "Error: Git is not installed or available in PATH." >&2
  exit 1
fi

# Ensure repository is a valid Git repo
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "Error: This is not a Git repository. Ensure the workflow runs after 'checkout'." >&2
  exit 1
fi

VERSION=$(date +'%Y%m%d-%H%M')-$(git rev-parse --short HEAD)

echo "Generated Image Version: $VERSION"
echo "IMAGE_VERSION=$VERSION" >> "$GITHUB_ENV"
echo "image_version=$VERSION" >> "$GITHUB_OUTPUT"
