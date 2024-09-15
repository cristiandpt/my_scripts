#!/bin/bash


output_latex_file=$1
source ../utils/files_in_directory_list.sh "../scripts" "self_description" "*.yaml"
echo "Enter the self description path: "
read -r self_description_path

# Extract the profile value from the YAML file and trim surrounding whitespace
description_value=$(awk -F': *' '/^self_description:/ {print $2}' "$self_description_path" | sed 's/^ *//;s/ *$//')

echo "$description_value"

source ./self_description_insertor.sh "$output_latex_file" "$description_value"

