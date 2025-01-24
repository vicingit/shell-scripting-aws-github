#!/bin/bash

# Script Name: list_read_access_users.sh
# Description: This script lists users with read access to a specified GitHub repository using the GitHub API.
# Author: Your Name
# Date: YYYY-MM-DD
# Version: 1.0

# GitHub API Base URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username  # Replace with your GitHub username or pass it as an environment variable
TOKEN=$token        # Replace with your personal access token or pass it as an environment variable

# Helper function to display script usage instructions
function display_help {
    echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
    echo ""
    echo "Arguments:"
    echo "  REPO_OWNER    The owner of the repository (GitHub username or organization name)"
    echo "  REPO_NAME     The name of the repository"
    echo ""
    echo "Example:"
    echo "  $0 octocat Hello-World"
}

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
if [[ $# -ne 2 ]]; then
    echo "Error: Invalid arguments provided."
    display_help
    exit 1
fi

REPO_OWNER=$1
REPO_NAME=$2

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
