#!/bin/bash

# set -x

echo "Before running this script, run the following with an account that has"
echo "  permission to create service accounts and add roles:"
echo ""
echo $ gcloud auth login
echo ""
echo "... and:"
echo ""
echo $ gcloud auth application-default login
echo ""

# Much of this could be run in terraform, but the key creation cannot, so we
#   just do the service account creation workflow here.

conf_yaml=dry-beans-config.yaml

project_id=$(yq .project_id < $conf_yaml)
svc_acct=$(yq .svc_acct < $conf_yaml)
key_file=$(yq .key_file < $conf_yaml)

if [ -z $project_id ] ; then
    echo "Error reading config: $conf_yaml"
    exit -1
fi

if [ -f $key_file ] ; then
    echo "Key file exists: $key_file"
else
    echo "Creating key file for the service account: $key_file"
    # If you get "FAILED_PRECONDITION: Key creation is not allowed on this service
    #   account", you'll need to turn off enforcement for the "Disable service
    #   account key creation" policy."
    # You'll need to do it for both the modern and the legacy versions:
    #   iam.disableServiceAccountCreation
    #   iam.managed.disableServiceAccountKeyCreation
    gcloud iam service-accounts keys create $key_file \
        --iam-account $svc_acct@$project_id.iam.gserviceaccount.com \
        || exit $?
fi









