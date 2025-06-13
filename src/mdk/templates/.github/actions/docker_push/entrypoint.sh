#!/bin/bash

set -e  # Exit immediately if a command fails

echo "Starting Docker push process..."

if [[ -z "$IMAGE_TAG" || -z "$REMOTE_REPO" ]]; then
  echo "ERROR: Missing required inputs."
  echo "Ensure 'image_tag' and 'remote_repository' are provided."
  exit 1
fi

echo "Image Tag: $IMAGE_TAG"
echo "Remote Repository: $REMOTE_REPO"

# Authenticate with Google Cloud Registry (GCR)
echo "Authenticating to Google Container Registry..."
gcloud auth configure-docker --quiet

# Tag the Docker image
# echo "Tagging Docker image: $IMAGE_TAG → $REMOTE_REPO"
# docker tag "$IMAGE_TAG" "$REMOTE_REPO"  # unnecessary step

# Retry logic for Docker push (3 attempts)
MAX_RETRIES=3
RETRY_DELAY=5  # seconds

for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "Attempt $i: Pushing Docker image to $REMOTE_REPO..."
  if docker push "$REMOTE_REPO"; then
    echo "Docker image pushed successfully: $REMOTE_REPO"
    exit 0
  else
    echo "Failed to push image. Retrying in $RETRY_DELAY seconds..."
    sleep "$RETRY_DELAY"
  fi
done

echo "ERROR: Docker push failed after $MAX_RETRIES attempts!"
exit 1
