#!/bin/bash

parse_yaml() {
    local prefix=$2
    local s='[[:space:]]*'
    local w='[a-zA-Z0-9_]*'
    local fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" $1 |
    awk -F$fs '{
        indent = length($1)/2;
        if (length($2) == 0) { conj[indent] = "" } else { conj[indent] = $2 }
        for (i in conj) { if (i > indent) { delete conj[i] } }
        if (length($3) > 0) {
            vn = "";
            for (i = 0; i < indent; i++) { vn = (vn)(conj[i])("_") }
            printf("%s%s%s=\"%s\"\n", "'$prefix'", vn, $2, $3);
        }
    }'
}
output_latex_file=$1
source ../utils/files_in_directory_list.sh "../scripts" "profile" "*.yaml"
echo "Enter the job profile path: "
read -r profile_path

result=$(parse_yaml "$profile_path" "")
echo "$result"

# Extract the profile value from the YAML file
profile_value=$(awk -F':' '/^profile:/ {print $2}' "$profile_path")

# Trim any surrounding whitespace (if needed)
profile_value=$(echo "$profile_value" | sed 's/^ *//;s/ *$//')
#sed -i "/[[:space:]]*%[[:space:]]*Job profile /a $profile_value" $1

echo "Modified $1 with profile content: $profile_value"
source ./insert_custom_profile.sh "$output_latex_file" "$profile_value"

