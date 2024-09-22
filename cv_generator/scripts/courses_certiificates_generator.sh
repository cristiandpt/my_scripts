#!/bin/bash

# Function to parse YAML file
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

function iterate_over_courses() {
    local -n courses_array="$1"
    echo "-----------Courses selected-------------"
    for course in "${courses_array[@]}"; do
        echo -e "$course"
    done
    echo "-------------------------------"
}

courses_templates_to_merge=()

source ../utils/files_in_directory_list.sh "../scripts" "courses" "*.yaml"
while true; do
    echo "Enter Courses YAML file...(done for exit)"
    read -r input_yaml_file
    courses_templates_to_merge+=("$input_yaml_file")
    if [ "$input_yaml_file" = "done" ]; then
        break
    fi
    iterate_over_courses courses_templates_to_merge
done


# Load YAML variables into environment
result=$(parse_yaml "$input_yaml_file" "")
echo "$result"

# Update LaTeX document based on YAML values
#sed -i "s/\\title{.*}/\\title{${config_title}} % TITLE/" document.tex
#sed -i "s/\\author{.*}/\\author{${config_author}} % AUTHOR/" document.tex
#sed -i "s/\\date{.*}/\\date{${config_date}} % DATE/" document.tex

## Define the output LaTeX file
output_latex_file=$1
temp_file="temp.tex" 

# Convert the YAML to LaTeX \cvitem entries
awk '
    $1 == "-" {
        split($0, year_entry, ":")
        gsub(/"/, "", year_entry[2])
        year = year_entry[2]  
        getline
        split($0, title_entry, ":")
        gsub(/"/, "", title_entry[2])
        title = title_entry[2]
        getline
        split($0, institution_entry, ":")
        gsub(/"/, "", institution_entry[2])
        institution = institution_entry[2]
        printf("    \\cvitem{%s}{%s}{%s}{}\n", year, title, institution)
    }
' "$input_yaml_file" > "$temp_file"

# Extract everything before \begin{cvtable} and after \end{cvtable}
source ./insert_courses.sh "$output_latex_file" "$temp_file"




