#!/bin/bash

output_latex_file=$1
hobbies_activities_content=$2

echo "$hobbies_activities_content" > temp_hobbies_activities_content

# Step 1: Write the content from the beginning to \begin{cvtable}
sed -n '1,/[[:space:]]*% -> Hobbies/p' "$output_latex_file" > temp_file
# Step 2: Append the content from \end{cvtable} onwards
sed -n '/[[:space:]]*% <- Hobbies/,$p' "$output_latex_file" >> temp_file

# Step 3: Replace the original file with the new content
mv temp_file "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document
sed -i '/[[:space:]]*% -> Hobbies/r temp_hobbies_activities_content' "$output_latex_file"
# Clean up temporary file if it exists

[ -f temp_hobbies_activities_content ] && rm temp_hobbies_activities_content

echo "LaTeX document generated Hobbies and activities entries: $output_latex_file."