#!/bin/bash


# The file to write the experience entries.
output_latex_file=$1
# The YAML file contains the experience data.
experiences=$2

echo "$experiences" > temp_experiences

# Fromw the first line to the the this pattern included
sed -n '1,/[[:space:]]*% -> Job Experience/p' "$output_latex_file" > temp_file

# In the range of the pattern until the end of the file
sed -n '/[[:space:]]*% <- Job Experience/,$p' "$output_latex_file" >> temp_file

mv temp_file "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document.
# The /r is for read the contents of the temp_file for inserti it to output_latex_file
sed -i '/[[:space:]]*% -> Job Experience/r temp_experiences' "$output_latex_file"
# Clean up temporary file if it exists
[ -f temp_experiences ] && rm temp_experiences

echo "LaTeX document generated experiences entries at $output_latex_file."

