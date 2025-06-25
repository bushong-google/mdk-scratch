#!/bin/bash

set -x

echo "Before running this script, run the following with an account that has"
echo "  permission to create service accounts and add roles:"
echo ""
echo gcloud auth login
echo ""

# Much of this could be run in terraform, but the key creation cannot, so we
#   just do the service account creation workflow here.

conf_yaml=dry-beans-config.yaml

project_id=$(yq .project_id < $conf_yaml)
svc_acct=$(yq .svc_acct < $conf_yaml)
key_file=$(yq .key_file < $conf_yaml)

# # Check whether service account already exists:
# gcloud iam service-accounts list \
#     | grep $svc_acct@$project_id.iam.gserviceaccount.com \
#     && svc_acct_exists=true || svc_acct_exists=false

# # Create a service account, if it does not exist.
# if [ $svc_acct_exists == true ] ; then
#     echo "Service account exists: $svc_acct"
# else
#     echo "Creating service account: $svc_acct"
#     # It's OK if this fails because the account already exists.
#     # The sed expression strips the domain off the service account name.
#     #gcloud iam service-accounts create $(echo $svc_acct | sed 's/@.*$//') \
#     gcloud iam service-accounts create $svc_acct \
#         --display-name="Service account for dry beans example" \
#         --project=$project_id
# fi

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

# for role in \
#         bigquery.user \
#         storage.objectUser \
#         ; do
#     echo "Adding role: $role"
#     #gcloud iam service-accounts add-iam-policy-binding \
#     #    $svc_acct@$project_id.iam.gserviceaccount.com \
#     gcloud projects add-iam-policy-binding $project_id \
#         --member=serviceAccount:$svc_acct@$project_id.iam.gserviceaccount.com \
#         --role=roles/$role \
#         || exit $?
# done








