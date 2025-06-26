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

# Migrate the TF state back end.
cd terraform || exit $?
terraform apply || exit $?



