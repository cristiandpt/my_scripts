#!/bin/bash

output_latex_file=$1
temp_courses_path=$2

echo "$courses_result" > temp_courses_result

sed -n '1,/[[:space:]]*% -> Courses and Certifications/p' "$output_latex_file" > temp_file
sed -n '/[[:space:]]*% <- Courses and Certifications/,$p' "$output_latex_file" >> temp_file

mv temp_file "$output_latex_file"
# Insert the new \cvitem entries into the main LaTeX document
sed -i '/[[:space:]]*% -> Courses and Certifications/r '"$temp_courses_path"'' "$output_latex_file"
# Clean up temporary file if it exists
[ -f temp_courses_result ] && rm temp_courses_result
[ -f "$temp_courses_path" ] && rm "$temp_courses_path"


echo "LaTeX document generated with new \cvitem entries at $temp_file."