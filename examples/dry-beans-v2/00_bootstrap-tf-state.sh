#!/bin/bash

echo "Before running this script, run the following with an account that has"
echo "  permission to create service accounts and add roles:"
echo ""
echo $ gcloud auth login
echo ""
echo "... and:"
echo ""
echo $ gcloud auth application-default login
echo ""

conf_yaml=dry-beans-config.yaml

project_id=$(yq .project_id < $conf_yaml)
region=$(yq .region < $conf_yaml)

if [ -z $project_id ] ; then
    echo "Error reading config: $conf_yaml"
    exit -1
fi

# Note: If you change this, it should be consistent with tf-state-bucket.tf .
tf_state_bucket=${project_id}-tfstate

echo "Enabling API: storage.googleapis.com"
gcloud services enable storage.googleapis.com --project=${project_id} || exit $?

# Check whether the TF state bucket already exists:
gcloud storage ls 2> /dev/null | grep $tf_state_bucket 2>/dev/null \
    && tf_state_bucket_exists=true || tf_state_bucket_exists=false

# Create a bucket, if it does not exist.
if [ $tf_state_bucket_exists == true ] ; then
    echo "Bucket already exists: $tf_state_bucket"
else
    gcloud storage buckets create gs://${tf_state_bucket} \
        --project=${project_id} \
        --location=${region} \
        --uniform-bucket-level-access \
        || exit $?
fi

# Enable versioning on the bucket
gcloud storage buckets update gs://${tf_state_bucket} --versioning || exit $?

# Verify bucket creation
gcloud storage ls || exit $?

# Migrate the TF state back end.
cd terraform || exit $?
terraform init || exit $?



