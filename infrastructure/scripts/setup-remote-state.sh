#!/bin/bash

# ==============================================================================
# Script Name: setup-remote-state.sh
# Description: Bootstraps the Azure Storage Account for Terraform Remote State.
#              Adheres to Altrivo Naming Conventions & Tagging Strategy.
# Region:      Central India
# Context:     This infrastructure is classified as PROD because State Files are 
#              critical permanent assets.
# Author:      Altrivo Platform Team
# ==============================================================================

# Stop script on any error
set -e

# --- 1. Variables (Aligned with Governance Docs) ---

# Project Name (Tag: Project)
PROJECT_NAME="azure-platform"     # Hyphenated as per Tagging Strategy
PROJECT_CODE="azureplatform"      # Alphanumeric for Resource Names (No hyphens)

# Environment (Tag: Environment)
# Allowed Values: dev, staging, prod
# Decision: 'prod' used because Terraform State is critical permanent infrastructure.
ENV_TAG="prod"
ENV_CODE="prod"

# Region
LOCATION="centralindia"
REGION_CODE="centralindia" # Full name preferred in RG, short code often used elsewhere

# Resource Group Name
# Pattern: rg-{project}-{env}-{region}-{instance}
RESOURCE_GROUP_NAME="rg-${PROJECT_CODE}-${ENV_CODE}-${REGION_CODE}-001"

# Container Name
CONTAINER_NAME="tfstate"

# TAGS (Aligned with tagging-strategy.md)
# Format: "Key=Value Key=Value"
TAGS="Project=${PROJECT_NAME} Environment=${ENV_TAG} Owner=platform-team CreatedBy=setup-remote-state.sh Criticality=High"

# --- 2. Random Suffix Generation ---
# Storage accounts must be globally unique and < 24 chars.
if command -v openssl &> /dev/null; then
    RANDOM_SUFFIX=$(openssl rand -hex 3)
else
    RANDOM_SUFFIX=$RANDOM
fi

# Storage Pattern: st{project}{env}{suffix}
# Checking length: st(2) + azureplatform(13) + prod(4) + suffix(6) = 25 chars.
# Azure Limit is 24 characters. We must shorten the project code for storage.
# storage_project_code="azplat" (6 chars)
STORAGE_PROJECT_CODE="azplat"
STORAGE_ACCOUNT_NAME="st${STORAGE_PROJECT_CODE}${ENV_CODE}${RANDOM_SUFFIX}"

# --- 3. Execution ---

echo "Starting Terraform State Bootstrapping..."
echo "------------------------------------------------"
echo "Region:          $LOCATION"
echo "Resource Group:  $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Container:       $CONTAINER_NAME"
echo "Tags:            $TAGS"
echo "------------------------------------------------"

# 3.1 Create Resource Group
echo "Creating Resource Group..."
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --tags $TAGS \
    --output none

# 3.2 Create Storage Account
# Standards: Standard_LRS, Hot Tier, TLS 1.2, No Public Blob Access
echo "Creating Storage Account..."
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --sku Standard_LRS \
    --kind StorageV2 \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false \
    --tags $TAGS \
    --output none

# 3.3 Create Blob Container
echo "Creating Blob Container..."
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --output none

# 3.4 Enable Data Protection (Versioning & Soft Delete)
# CRITICAL: Prevents accidental loss of state files.
echo "Enabling Blob Versioning & Soft Delete..."
az storage account blob-service-properties update \
    --account-name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --enable-versioning true \
    --enable-delete-retention true \
    --delete-retention-days 7 \
    --enable-container-delete-retention true \
    --container-delete-retention-days 7 \
    --output none

# 3.5 Retrieve Access Key (For local testing only)
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

echo "------------------------------------------------"
echo "✅ SUCCESS: Remote State Infrastructure Created!"
echo "------------------------------------------------"
echo "Details for your 'backend' configuration:"
echo "resource_group_name  = \"$RESOURCE_GROUP_NAME\""
echo "storage_account_name = \"$STORAGE_ACCOUNT_NAME\""
echo "container_name       = \"$CONTAINER_NAME\""
echo "key                  = \"terraform.tfstate\""
echo "------------------------------------------------"
echo "⚠️  SECRET: Storage Account Access Key (Save this securely, do not commit):"
echo "$ACCOUNT_KEY"
echo "------------------------------------------------"