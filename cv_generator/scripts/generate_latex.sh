#!/bin/bash

input_latex_file=$1
output_latex_file=$2
temp_file=$3

sed -n '1,/\\begin{cvtable}[[:space:]]*%[[:space:]]*Courses and Certifications/p' "$input_latex_file" > "$output_latex_file"
sed -n '/\\end{cvtable}[[:space:]]*%[[:space:]]*Courses and Certifications/,$p' "$input_latex_file" >> "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document
sed -i '/\\begin{cvtable}[[:space:]]*%[[:space:]]*Courses and Certifications/r '"$temp_file"'' "$output_latex_file"
# Clean up temporary file if it exists
[ -f "$temp_file" ] && rm "$temp_file"

echo "LaTeX document generated with new \cvitem entries at $temp_file."