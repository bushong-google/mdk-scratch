#!/bin/bash

set -e  # Exit on any error

echo "Authenticating with GCP..."
gcloud auth configure-docker

echo "Deploying $SERVICE_NAME to Google Cloud Run in project $GCP_PROJECT_ID..."

DEPLOY_CMD="gcloud run deploy \"$SERVICE_NAME\" \
  --image \"$IMAGE_URL\" \
  --region \"$REGION\" \
  --project \"$GCP_PROJECT_ID\" \
  --platform managed \
  --quiet"

if [ "$ALLOW_UNAUTHENTICATED" = "true" ]; then
  DEPLOY_CMD="$DEPLOY_CMD --allow-unauthenticated"
fi

echo "Running: $DEPLOY_CMD"
if ! eval "$DEPLOY_CMD"; then
  echo "Deployment failed! Retrieving error logs..."

  # Fetch and display Cloud Run error logs
  gcloud run services describe "$SERVICE_NAME" \
    --region "$REGION" \
    --format=json | jq '.status.conditions'

  echo "Rolling back to the last working version..."
  gcloud run services update-traffic "$SERVICE_NAME" \
    --region "$REGION" --to-latest
  exit 1
fi

echo "Deployment completed successfully!"
