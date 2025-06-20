#!/bin/bash

# set -x

project_id=pso-hca-mlops
dataset_id=dry_beans
region=us-central1
bucket=${project_id}-data
csv=Dry_Beans_Dataset.csv
table=features

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
