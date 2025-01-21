#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------
# Google Groups Creation Helper Script
# ---------------------------------------------------------------------------------------------------------------------
# This script helps you create the required Google Groups for the GenAI Pipeline project.
# Note: Google Groups must be created through Google Workspace/Cloud Identity Admin Console.
# This script will:
# 1. Guide you through the project selection process
# 2. Guide you through the group creation process
# 3. Verify the groups exist and have the correct permissions
# 4. Update terraform.tfvars with the group email addresses
# ---------------------------------------------------------------------------------------------------------------------

set -e # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Verify gcloud is installed and user is authenticated
print_step "Verifying gcloud installation and authentication..."
if ! command -v gcloud &> /dev/null; then
    print_error "gcloud CLI is not installed. Please install it first."
    exit 1
fi

if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    print_error "Not authenticated with gcloud. Please run 'gcloud auth login' first."
    exit 1
fi

# Interactive project selection
print_step "Fetching available projects..."
echo "This may take a few moments..."
echo ""

# Get list of projects user has access to
projects=($(gcloud projects list --format="value(projectId,name)" | sort))

if [ ${#projects[@]} -eq 0 ]; then
    print_error "No projects found. Please ensure you have access to at least one GCP project."
    exit 1
fi

# Display projects with numbers
echo "Available projects:"
echo "-----------------"
project_count=${#projects[@]}
for ((i=0; i<$project_count; i+=2)); do
    project_id=${projects[$i]}
    project_name=${projects[$i+1]}
    project_num=$((i/2+1))
    printf "%3d) %-40s [%s]\n" $project_num "$project_name" "$project_id"
done
echo ""

# Get user selection
while true; do
    read -p "Select a project number (1-$((project_count/2))): " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le $((project_count/2)) ]; then
        break
    fi
    print_error "Invalid selection. Please enter a number between 1 and $((project_count/2))"
done

# Set the selected project
selected_index=$(((selection-1)*2))
PROJECT_ID=${projects[$selected_index]}

print_step "Setting active project to: $PROJECT_ID"
if ! gcloud config set project "$PROJECT_ID" &> /dev/null; then
    print_error "Failed to set project. Please ensure you have sufficient permissions."
    exit 1
fi

# Verify project access
print_step "Verifying project access..."
if ! gcloud projects describe "$PROJECT_ID" &> /dev/null; then
    print_error "Unable to access project: $PROJECT_ID"
    exit 1
fi

print_step "Successfully set project to: $PROJECT_ID"
echo ""

# Instructions for creating groups
print_step "Google Groups Creation Instructions:"
echo "1. Go to https://admin.google.com/ac/groups"
echo "2. Click 'Create Group' and create two groups:"
echo "   a. Data Readers Group (e.g., 'genai-data-readers@your-domain.com')"
echo "   b. Restricted Users Group (e.g., 'genai-restricted-users@your-domain.com')"
echo ""

# Get group email addresses
read -p "Enter the Data Readers group email address: " READER_GROUP_EMAIL
read -p "Enter the Restricted Users group email address: " RESTRICTED_GROUP_EMAIL

# Verify groups exist by checking IAM permissions
print_step "Verifying groups exist..."

verify_group() {
    local group_email=$1
    local group_type=$2
    
    # Try to add the group to the project with viewer role (will be removed)
    if gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="group:$group_email" \
        --role="roles/viewer" &> /dev/null; then
        
        # Remove the test binding
        gcloud projects remove-iam-policy-binding "$PROJECT_ID" \
            --member="group:$group_email" \
            --role="roles/viewer" &> /dev/null
        
        print_step "$group_type group verified: $group_email"
        return 0
    else
        print_error "$group_type group not found or not accessible: $group_email"
        return 1
    fi
}

verify_group "$READER_GROUP_EMAIL" "Reader"
verify_group "$RESTRICTED_GROUP_EMAIL" "Restricted Users"

# Update terraform.tfvars
TFVARS_FILE="../terraform/terraform.tfvars"
print_step "Updating terraform.tfvars..."

if [ -f "$TFVARS_FILE" ]; then
    # Create backup
    cp "$TFVARS_FILE" "${TFVARS_FILE}.bak"
    
    # Update the values using sed
    sed -i '' "s|reader_group_email.*=.*|reader_group_email         = \"$READER_GROUP_EMAIL\"                                 # Group email for read access|" "$TFVARS_FILE"
    sed -i '' "s|restricted_users_group.*=.*|restricted_users_group     = \"$RESTRICTED_GROUP_EMAIL\"                                 # Group with restricted column access|" "$TFVARS_FILE"
    sed -i '' "s|project_id.*=.*|project_id     = \"$PROJECT_ID\"      # The GCP project ID where resources will be created|" "$TFVARS_FILE"
    
    print_step "Successfully updated terraform.tfvars"
    echo "Backup created at ${TFVARS_FILE}.bak"
else
    print_error "terraform.tfvars not found at $TFVARS_FILE"
    exit 1
fi

echo ""
print_step "Setup complete! Next steps:"
echo "1. Verify the project ID and group email addresses in terraform.tfvars"
echo "2. Add members to your groups in the Google Workspace Admin Console"
echo "3. Proceed with terraform deployment" 