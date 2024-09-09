#!/bin/bash

# The YAML file contains the experience data.
hobbies = $1
# The file to write the experience entries.
output_latex_file = $2
# The temporary file to store the generate fragment.
temp_file = $3

# Fromw the first line to the the this pattern included
sed -n '1,/*% -> Hobbies/p' "$hobbies" > "$output_latex_file"

# In the range of the pattern until the end of the file
sed -n '/*% <- Hobbies/,$p' "$hobbies" >> "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document.
# The /r is for read the contents of the temp_file for inserti it to output_latex_file
sed -i '/*% -> Hobbies/r '"$temp_file"'' "$output_latex_file"
# Clean up temporary file if it exists
[ -f "$temp_file" ] && rm "$temp_file"

echo "LaTeX document generated with new \cvitem Hobbies entries at $temp_file."
