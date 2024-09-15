#!/bin/bash
# The YAML file contains the experience data.
education_result=$2
# The file to write the experience entries.
output_latex_file=$1
# The temporary file to store the generate fragment.

echo "$education_result" > temp_education_result

# Fromw the first line to the the this pattern included
sed -n '1,/[[:space:]]*% -> Education/p' "$output_latex_file" > temp_file
sed -n '/[[:space:]]*% <- Education/,$p' "$output_latex_file" >> temp_file

mv temp_file "$output_latex_file"

sed -i '/[[:space:]]*% -> Education/r temp_education_result' "$output_latex_file"

# Clean up temporary file if it exists
[ -f temp_education_result ] && rm temp_education_result

echo "LaTeX document generated with new Education entries at $output_latex_file."


