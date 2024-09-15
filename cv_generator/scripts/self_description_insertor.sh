#!/bin/bash

output_latex_file=$1
self_description_content=$2
echo "$self_description_content" > temp_description_content

# Step 1: Write the content from the beginning to \begin{cvtable}
sed -n '1,/[[:space:]]*% -> About me/p' "$output_latex_file" > temp_file
# Step 2: Append the content from \end{cvtable} onwards
sed -n '/[[:space:]]*% <- About me/,$p' "$output_latex_file" >> temp_file

# Step 3: Replace the original file with the new content
mv temp_file "$output_latex_file"

# Insert the new \cvitem entries into the main LaTeX document
sed -i '/[[:space:]]*% -> About me/r temp_description_content' "$output_latex_file"
# Clean up temporary file if it exists

[ -f temp_description_content ] && rm temp_description_content

echo "LaTeX document generated About me entry: $output_latex_file."