#!/bin/bash

source ../utils/files_in_directory_list.sh "../scripts" "education" "*.yaml"
echo "Enter the education path: "
read -r education

output_latex_file=$1

result=$(awk -F'-'  '
{
    getline
    split($0, year_entry, ":")
    gsub(/"/, "", year_entry[2])
    year = year_entry[2]  
    getline
    split($0, grade_entry, ":")
    gsub(/"/, "", grade_entry[2])
    grade = grade_entry[2]
    getline
    split($0, institution_entry, ":")
    gsub(/"/, "", institution_entry[2])
    institution = institution_entry[2]
    getline
    split($0, focus_entry, ":")
    gsub(/"/, "", focus_entry[2])
    focus = focus_entry[2]
    printf("    \\cvitem{%s}{%s}{%s}{%s}\n", year, grade, institution, focus)
}
END {
    # Print the LaTeX table end
    print "\\end{cvtable}"
}
' "$education")

result=$(cat <<EOF
\cvsection{Educación}
\cvsubsection{Estudios}
\begin{cvtable}[1.5]
${result}
\end{cvtable}
EOF
)


echo "$result"

source ./education_insertion.sh "$output_latex_file" "$result"