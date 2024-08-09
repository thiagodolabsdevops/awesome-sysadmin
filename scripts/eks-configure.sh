#!/bin/bash

set -e

# Error handling
error_exit() {
    echo "Error on line $1"
    exit 1
}

trap 'error_exit $LINENO' ERR

# Copy awsconfig to ~/.aws/config
AWS_CONFIG_FILE="awsconfig"
AWS_CONFIG_DIR="$HOME/.aws"
AWS_CONFIG_PATH="$AWS_CONFIG_DIR/config"

# Function to check if a file is a subset of another
is_subset() {
    grep -Fxq "$1" "$2"
}

# Copy and validate the awsconfig file content
if [ -f "$AWS_CONFIG_FILE" ]; then
    echo "Validating contents of $AWS_CONFIG_FILE..."
    mkdir -p "$AWS_CONFIG_DIR"

    while IFS= read -r line; do
        if ! is_subset "$line" "$AWS_CONFIG_PATH"; then
            echo "$line" >> "$AWS_CONFIG_PATH"
        fi
    done < "$AWS_CONFIG_FILE"

    echo "$AWS_CONFIG_FILE content added to $AWS_CONFIG_PATH if necessary."
else
    echo "$AWS_CONFIG_FILE does not exist. Skipping the copy step."
fi


# Validate env input
ENVIRONMENT=${1:-sandbox} # Default to sandbox if no argument is provided
VALID_ENVIRONMENTS=("sandbox" "pre-prod" "prod")

if [[ ! " ${VALID_ENVIRONMENTS[@]} " =~ " ${ENVIRONMENT} " ]]; then
    echo "Invalid environment: ${ENVIRONMENT}. Valid options are: ${VALID_ENVIRONMENTS[*]}"
    exit 1
fi

AWS_PROFILE="lh-${ENVIRONMENT}"
REGION="us-east-1"
CLUSTERS=("aw-lighthouse-$ENVIRONMENT-1" "aw-lighthouse-$ENVIRONMENT-2")

# AWS SSO login
echo "Logging in to AWS SSO with profile $AWS_PROFILE..."
aws sso login --profile "$AWS_PROFILE"
echo "Complete the authentication process in your browser."

# Check successful AWS SSO login 
if ! aws sts get-caller-identity --profile "$AWS_PROFILE" &>/dev/null; then
    echo "AWS SSO login failed. Complete the authentication in your browser."
    exit 1
fi

# Update kubeconfig
for CLUSTER in "${CLUSTERS[@]}"; do
    echo "Updating kubeconfig for cluster $CLUSTER in region $REGION..."
    if ! aws eks update-kubeconfig --name "$CLUSTER" --region "$REGION" --profile "$AWS_PROFILE"; then
        echo "Failed to update kubeconfig for cluster $CLUSTER. Check the cluster name and region."
        exit 1
    fi
done

echo "Kubeconfig updated successfully for environment: $ENVIRONMENT"