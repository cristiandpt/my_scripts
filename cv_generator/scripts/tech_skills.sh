#!/bin/bash

source ../utils/files_in_directory_list.sh "../scripts" "tech_skills" "*.yaml"
echo "Enter the tech skill path: "
read -r skills

output_latex_file=$1

result=$(awk '
    $1 == "-" {
        # Remove the leading hyphen and any surrounding quotes or whitespace
        skill = $2
        gsub(/"/, "", skill)
        gsub(/^[ \t]+|[ \t]+$/, "", skill)

        # Print the skill in LaTeX \cvitem format
        printf("         \\chartlabel{%s}\n", skill)
    }
' "$skills")

echo "$result"

source ./tech_skills_insertor.sh "$output_latex_file" "$result"
