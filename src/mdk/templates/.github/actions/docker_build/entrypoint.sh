#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

echo "Starting Docker build process..."
echo "Image Tag: $IMAGE_TAG"
echo "Build Context: $BUILD_CONTEXT"
echo "Dockerfile: $DOCKERFILE"
echo "Build Args: $BUILD_ARGS"
echo "Target Platform: $PLATFORM"

# Enable BuildKit for better caching and parallel builds
export DOCKER_BUILDKIT=1

# Construct Docker build command
DOCKER_BUILD_CMD="docker buildx build --load --platform $PLATFORM -t $IMAGE_TAG -f $DOCKERFILE $BUILD_CONTEXT --progress=plain"

# If build arguments are provided, add them dynamically
if [[ -n "$BUILD_ARGS" ]]; then
  IFS=',' read -ra ARG_LIST <<< "$BUILD_ARGS"
  for ARG in "${ARG_LIST[@]}"; do
    DOCKER_BUILD_CMD="$DOCKER_BUILD_CMD --build-arg $ARG"
  done
fi

echo "Running: $DOCKER_BUILD_CMD"
eval "$DOCKER_BUILD_CMD"

echo "Docker image built successfully: $IMAGE_TAG"
