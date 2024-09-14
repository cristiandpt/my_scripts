#!/bin/bash

script_dir=$1
directory_look_for=$2
file_regex=$3

lookup_templates() {
    found_templates=$(find "$script_dir/../$directory_look_for" -type f -name "$file_regex" -print | sed "s|$script_dir/../|../|")
    result_count=$(echo "$found_templates" | wc -l)
    if [ "$result_count" -gt 0 ]; then
	echo "Found $result_count templates in $directory_look_for directory"
    echo -e "\n"
	for template in $found_templates; do 
	    echo -e "\t - $template"
	done
    echo -e "\n"
	echo "Choose one of these"
    fi
}

lookup_templates 