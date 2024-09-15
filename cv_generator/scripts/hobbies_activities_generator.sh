#!/bin/bash
source ../utils/files_in_directory_list.sh "../scripts" "hobbies_activities" "*.yaml"

echo "Enter the hobbies path: "
read -r hobbies

output_latex_file=$1

result=$(awk -F'-'  '
{
    getline
    split($0, hobbie_entry, ":")
    gsub(/"/, "", hobbie_entry[2])
    hobbie = hobbie_entry[2]  
    getline
    split($0, description_entry, ":")
    gsub(/"/, "", description_entry[2])
    description = description_entry[2]
    printf("    \\cvitem{%s}{%s}\n", hobbie, description)
}
' "$hobbies")

result=$(cat <<EOF
\cvsection{\LARGE Hobbies}
\begin{cvtable}[3]
${result}
\end{cvtable}
EOF
)

echo "$result"

hobbies_value=$(echo "$result" | sed 's/^ *//;s/ *$//')

source ./hobbies_activities_insertor.sh "$output_latex_file" "$hobbies_value"



#section_title="Experiencia laboral"
#table_options="[3]"

#result=$(awk -F'-v' -v title="$section_title" -v options="$table_options" '
#BEGIN {
#    # Print the LaTeX section and table start using external variables
#    print "\\cvsection{" title "}"
#    print "\\begin{cvtable}" options
#}
#
#{
#    getline
#    split($0, position_entry, ":")
#    gsub(/"/, "", position_entry[2])
#    position = position_entry[2]  
#    getline
#    split($0, enterprise_entry, ":")
#    gsub(/"/, "", enterprise_entry[2])
#    enterprise = enterprise_entry[2]
#    getline
#    split($0, description_entry, ":")
#    gsub(/"/, "", description_entry[2])
#    description = description_entry[2]
#    getline
#    split($0, range_entry, ":")
#    gsub(/"/, "", range_entry[2])
#    range = range_entry[2]
#    # Append formatted string to result
#    printf("    \\cvitem{%s}{%s}{%s}{%s}\n", position, enterprise, description, range)
#}
#END {
#    # Print the LaTeX table end
#    print "\\end{cvtable}"
#}' "$job_experiences")
#
## Print or use the result
#echo "$result"
#