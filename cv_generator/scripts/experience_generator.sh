#!/bin/bash

# The YAML file contains the experience data.
experiences = $1
# The file to write the experience entries.
output_latex_file = $2
# The temporary file to store the generate fragment.
temp_file = $3

# Fromw the first line to the the this pattern included
sed -n '1,/\\begin{cvtable}[[:space:]]*%[[:space:]]*Experiences/p' "$input_latex_file" > "$output_latex_file"

# In the range of the pattern until the end of the file
sed -n '/\\end{cvtable}[[:space:]]*%[[:space:]]*Experiences/,$p' "$input_latex_file" >> "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document.
# The /r is for read the contents of the temp_file for inserti it to output_latex_file
sed -i '/\\begin{cvtable}[[:space:]]*%[[:space:]]*Experiences/r '"$temp_file"'' "$output_latex_file"
# Clean up temporary file if it exists
[ -f "$temp_file" ] && rm "$temp_file"

echo "LaTeX document generated with new \cvitem entries at $temp_file."

