#!/bin/bash

output_latex_file=$1
tech_skills_content=$2
echo "$tech_skills_content" > temp_tech_skills_content

# Step 1: Write the content from the beginning to \begin{cvtable}
sed -n '1,/[[:space:]]*% -> Tech skills/p' "$output_latex_file" > temp_file
# Step 2: Append the content from \end{cvtable} onwards
sed -n '/[[:space:]]*% <- Tech skills/,$p' "$output_latex_file" >> temp_file

# Step 3: Replace the original file with the new content
mv temp_file "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document
sed -i '/[[:space:]]*% -> Tech skills/r temp_tech_skills_content' "$output_latex_file"
# Clean up temporary file if it exists

[ -f temp_tech_skills_content ] && rm temp_tech_skills_content

echo "LaTeX document generated About me entry: $output_latex_file."