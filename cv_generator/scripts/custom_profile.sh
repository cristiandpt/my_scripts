echo "Enter the jub profile path: "
read -r profile_path

# Extract the profile value from the YAML file
profile_value=$(awk -F':' '/^profile:/ {print $2}' "$profile_path")

# Trim any surrounding whitespace (if needed)
profile_value=$(echo "$profile_value" | sed 's/^ *//;s/ *$//')
sed -i "/[[:space:]]*%[[:space:]]*Job profile /a $profile_value" $1
echo "Modified $1 with profile content: $profile_value"

