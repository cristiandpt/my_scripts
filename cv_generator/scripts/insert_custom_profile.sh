#!/bin/bash

output_latex_file=$1
profile_content=$2
echo "$profile_content" > temp_profile_content

# Step 1: Write the content from the beginning to \begin{cvtable}
sed -n '1,/[[:space:]]*%[[:space:]]*% -> Job profile/p' "$output_latex_file" > temp_file
# Step 2: Append the content from \end{cvtable} onwards
sed -n '/[[:space:]]*%[[:space:]]*% <- Job profile/,$p' "$output_latex_file" >> temp_file

# Step 3: Replace the original file with the new content
mv temp_file "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document
sed -i '/[[:space:]]*% -> Job profile/r temp_profile_content' "$output_latex_file"
# Clean up temporary file if it exists

[ -f temp_profile_content ] && rm temp_profile_content

echo "LaTeX document generated with profile entry: $profile_content."