#!/bin/bash

options=("1. Professional Profile" "2. Education" "3. Courses and Certifications" "4. Job experience" "5. Self Description" "6. Hobbies and activities" "7. Exit")

output_latex_file="../output/output_$(date +%Y-%m-%d_%H-%M-%S).tex"

#!/bin/bash

# Get the directory of the current script
script_dir=$(dirname "$0")

print_options() {
    for option in "${options[@]}"; do
        echo "$option"
    done
}

header() {
    echo "==========================="
    echo "     CV Field Generator    "
    echo "==========================="
}

footer() {
    echo "==========================="
    echo -n "Please enter your choice [1-5]: "
}

# Function to display the menu
display_menu() {
    clear
    header
    print_options
    footer
}

# Function to handle the user's choice
handle_choice() {
    case $1 in
        1) source ./custom_profile.sh "$output_latex_file";;
        2) source ./education_generator.sh "$output_latex_file" ;;
        3) source ./courses_certiificates_generator.sh "$output_latex_file" ;;
        4) source ./jobs_experience.sh "$output_latex_file";;
        5) source ./tech_skills.sh "$output_latex_file";;
        6) source ./hobbies_activities.sh "$output_latex_file";;
        7) echo "Exiting..." ; exit 0 ;;
        *) echo "Invalid choice. Please select a number between 1 and 4." ;;
    esac
}

lookup_templates() {
    source ../utils/files_in_directory_list.sh "$script_dir" "templates" "*.tex"
}

prompt_for_input() {
    echo -e "Welcome to CV Generator \n"
    echo "To get started, enter the template path: "
    # Find files with a specific extension (.txt) in the parent directory
    # and print the relative path (from the script location)
    lookup_templates	    
    read -r template_path #< <(echo "a path") # This commented code was for testing the programaticality input
    if [ -z "$template_path" ]; then
        template_path="../templates/template_with_photo.tex"
    fi 
    if [[ $- == *x* ]]; then
    # Echo the command if the script is in debug mode
        cat "$template_path"
    fi   
}

prompt_for_input

cp "$template_path" "$output_latex_file" 
# Main loop
while true; do
    display_menu
    read -r choice
    handle_choice "$choice"
    echo "Press Enter to continue..."
    read -r
done
 
