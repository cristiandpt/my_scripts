#!/bin/bash

echo "Enter the education path: "
read -r education

output_latex_file=$1

result=$(awk -F'-'  '
{
- year: "2022 -- 2024"
    grade: "Ingeniería en Sistemas"
    institution: "Universidad del Valle"
    focus: "Ciclo de desarrollo de software"

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

result="\cvsection{Experiencia laboral}\n\\begin{cvtable}[3]\n${result}\n"

echo "$result"

profile_value=$(echo "$result" | sed 's/^ *//;s/ *$//')
sed -i "/[[:space:]]*%[[:space:]]*Job Experieence /a $profile_value" $1
echo "Modified $1 with job experience: $profile_value"