#!/bin/bash
options=("1. Professional Profile" "2. Courses and Certifications" "3. Job experience" "4. Self Description")

output_latex_file="../output/output_$(date +%Y-%m-%d_%H-%M-%S).tex"

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
    echo -n "Please enter your choice [1-4]: "
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
        2) source  ./cv_generator.sh "$template_path" "$output_latex_file" ;;
        3) echo "You selected Option 3" ;;
        4) echo "Exiting..." ; exit 0 ;;
        *) echo "Invalid choice. Please select a number between 1 and 4." ;;
    esac
}

prompt_for_input() {
    echo "Enter the template path: "
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
 
