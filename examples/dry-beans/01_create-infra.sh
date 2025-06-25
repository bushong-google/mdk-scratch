#!/bin/bash

echo "Before running this script, run the following with an account that has"
echo "  permission to create service accounts and add roles:"
echo ""
echo $ gcloud auth login
echo ""

# conf_yaml=dry-beans-config.yaml

# project_id=$(yq .project_id < $conf_yaml)
# region=$(yq .region < $conf_yaml)
# tf_state_bucket=$(yq .tf_state_bucket < $conf_yaml)

# echo "Enabling API: storage.googleapis.com"
# gcloud services enable storage.googleapis.com --project=${project_id} || exit $?

# # Check whether the TF state bucket already exists:
# gcloud storage ls | grep $tf_state_bucket 2>/dev/null\
#     && tf_state_bucket_exists=true || tf_state_bucket_exists=false

# # Create a bucket, if it does not exist.
# if [ $tf_state_bucket_exists == true ] ; then
#     echo "Bucket already exists: $tf_state_bucket"
# else
#     gcloud storage buckets create gs://${tf_state_bucket} \
#         --project=${project_id} \
#         --location=${region} \
#         --uniform-bucket-level-access \
#         || exit $?
# fi

# # Enable versioning on the bucket
# gcloud storage buckets update gs://${tf_state_bucket} --versioning || exit $?

# # Verify bucket creation
# gcloud storage ls || exit $?

# Migrate the TF state back end.
cd terraform || exit $?
terraform apply || exit $?



