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
    if [ "$input_yaml_file" = "done" ]; then
        break
    fi
     if [[ -f "$input_yaml_file" ]]; then
        courses_templates_to_merge+=("$input_yaml_file")
        iterate_over_courses courses_templates_to_merge
    else
        echo "File '$input_yaml_file' not found. Please try again."
    fi
done

# Clear or create merged YAML file with a single "courses:" entry
echo "courses: " > merged_courses.yaml


for file in "${courses_templates_to_merge[@]}"; do 
    echo "Processing file: $file"
    
    # Debug: show the content of the current file
    cat "$file"
    echo "------------------------------------------------------------------"
    
    # Append only the course entries (lines starting with '  - ') from the file
    awk '/^[[:space:]]*-/{f=1} f{print}' "$file" >> merged_courses.yaml
    
    cat merged_courses.yaml
    echo "------------------------------------------------------------------"
done

# Display the merged YAML file
cat merged_courses.yaml

# Parse merged YAML (if you have parse_yaml function)
# result=$(parse_yaml merged_courses.yaml "")
# echo "$result"

# Define the output LaTeX file
output_latex_file=$1

temp_file="temp.tex"
# Convert YAML content to LaTeX using awk
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
        getline
        split($0, url_entry, ":")
        gsub(/"/, "", url_entry[2])
        url = url_entry[2]
        # Output LaTeX entry for each course
        printf("    \\cvitem{%s}{%s}{%s}{%s}\n", year, title, institution, url)
    }
' merged_courses.yaml > "$temp_file"

sed -i.bak 's/\\&/\&/g' "$temp_file"

cat temp.tex
# Insert the LaTeX entries into the output file
source ./insert_courses.sh "$output_latex_file" "$temp_file"

# Clean up temporary file
if [ -f temp.tex ]; then
    rm temp.tex
fi

echo "LaTeX course entries have been generated and inserted into $output_latex_file."
# Convert YAML content to LaTeX using awk


# Clean up temporary file


#for file in "${courses_templates_to_merge[@]}"; do
#    sed '1d' "$file"  >> merged_courses.yaml
#done

#cat merged_courses.yaml

# Load YAML variables into environment
#result=$(parse_yaml merged_courses.yaml "")
#echo "$result"

# Update LaTeX document based on YAML values
#sed -i "s/\\title{.*}/\\title{${config_title}} % TITLE/" document.tex
#sed -i "s/\\author{.*}/\\author{${config_author}} % AUTHOR/" document.tex
#sed -i "s/\\date{.*}/\\date{${config_date}} % DATE/" document.tex

## Define the output LaTeX file
#output_latex_file=$1
#temp_file="temp.tex" 

# Convert the YAML to LaTeX \cvitem entries
#awk '
#    $1 == "-" {
#        split($0, year_entry, ":")
#        gsub(/"/, "", year_entry[2])
#        year = year_entry[2]  
#        getline
#        split($0, title_entry, ":")
#        gsub(/"/, "", title_entry[2])
#        title = title_entry[2]
#        getline
#        split($0, institution_entry, ":")
#        gsub(/"/, "", institution_entry[2])
#        institution = institution_entry[2]
#        printf("    \\cvitem{%s}{%s}{%s}{}\n", year, title, institution)
#    }
#' merged_courses.yaml > "$temp_file"

# Extract everything before \begin{cvtable} and after \end{cvtable}
#source ./insert_courses.sh "$output_latex_file" "$temp_file"




