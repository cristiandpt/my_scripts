#!/bin/bash

source ../utils/files_in_directory_list.sh "../scripts" "experience" "*.yaml"

echo "Enter the job experience file path: "
read -r job_experiences

output_latex_file=$1

result=$(awk -F'-'  '
{
    getline
    split($0, position_entry, ":")
    gsub(/"/, "", position_entry[2])
    position = position_entry[2]  
    getline
    split($0, enterprise_entry, ":")
    gsub(/"/, "", enterprise_entry[2])
    enterprise = enterprise_entry[2]
    getline
    split($0, description_entry, ":")
    gsub(/"/, "", description_entry[2])
    description = description_entry[2]
    getline
    split($0, range_entry, ":")
    gsub(/"/, "", range_entry[2])
    range = range_entry[2]
    printf("    \\cvitem{%s}{%s}{%s}{%s}\n", position, enterprise, description, range)
}
END {
    # Print the LaTeX table end
    print "\\end{cvtable}"
}
' "$job_experiences")

result=$(cat <<EOF
\cvsection{Experiencia laboral}
\begin{cvtable}[3]
${result}
EOF
)

echo "$result"

./experience_insertor.sh "$output_latex_file" "$result"