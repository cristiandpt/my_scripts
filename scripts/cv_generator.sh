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

echo "Enter Profile YAML file..."
read -r input_yaml_file
# Load YAML variables into environment
result=$(parse_yaml "$input_yaml_file" "")
echo "$result"

# Update LaTeX document based on YAML values
#sed -i "s/\\title{.*}/\\title{${config_title}} % TITLE/" document.tex
#sed -i "s/\\author{.*}/\\author{${config_author}} % AUTHOR/" document.tex
#sed -i "s/\\date{.*}/\\date{${config_date}} % DATE/" document.tex

## Define the output LaTeX file
output_latex_file=$2
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

# Define the input LaTeX file and the output LaTeX fragment file
input_latex_file="$1"  # Your main LaTeX document
 # Temporary file to store intermediate results

# Extract everything before \begin{cvtable} and after \end{cvtable}
source ./generate_latex.sh "$input_latex_file" "$output_latex_file" "$temp_file"




