#!/bin/bash

set -x

# Read our config file.

conf_yaml=dry-beans-config.yaml

project_id=$(yq .project_id < $conf_yaml)
dataset_id=$(yq .dataset_id < $conf_yaml)
region=$(yq .region < $conf_yaml)
bucket=$(yq .bucket < $conf_yaml)
csv=$(yq .csv < $conf_yaml)
table=$(yq .table < $conf_yaml)
key_file=$(yq .key_file < $conf_yaml)

if [ -z $project_id ] ; then
    echo "Error reading config: $conf_yaml"
    exit -1
fi


# Activate our service account.
gcloud auth activate-service-account $svc_acct --key-file $key_file \
    || exit $?

echo "Checking whether dataset exists: $project_id:$dataset_id"
bq --location $region ls --dataset_id $project_id:$dataset_id \
    && dataset_exists=true || dataset_exists=false

# Create a dataset, if it does not exist.
if [ $dataset_exists == true ] ; then
    echo "$project_id:$dataset_id exists => skipping"
else
    echo "$project_id:$dataset_id does not exist => creating"
    bq \
        --location=$region \
        mk \
        --dataset \
        ${project_id}:${dataset_id} \
        || exit $?
fi

# Upload our CSV.
echo "Uploading: ${bucket}/$csv"
gcloud storage cp "$csv" gs://$bucket/ || exit $?

# (Re-) create our table.
echo "(Re-) creating: $project_id:$dataset_id.$table"
bq rm --force --table "$project_id:$dataset_id.$table" || exit $?
bq mk --table "$project_id:$dataset_id.$table" \
area:integer,\
perimeter:float,\
major_axis_length:float,\
minor_axis_length:float,\
aspect_ratio:float,\
eccentricity:float,\
convex_area:float,\
equiv_diameter:float,\
extent:float,\
solidity:float,\
roundness:float,\
compactness:float,\
shape_factor_1:float,\
shape_factor_2:float,\
shape_factor_3:float,\
shape_factor_4:float,\
class:string \
    || exit $?

# Load our CSV.
echo "Loading: gs://$bucket/$csv"
bq \
    --location=$region \
    load \
    --source_format=CSV \
    --skip_leading_rows=1 \
    "$project_id:$dataset_id.$table" \
    gs://$bucket/$csv \
    || exit $?

echo "Load complete."
