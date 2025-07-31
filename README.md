Snowflake PrivateLink with Azure Terraform Project
This repository contains Terraform configurations to set up Snowflake PrivateLink connectivity with an Azure tenant. The project is structured into two main modules: azure for Azure-specific resources and snowflake for Snowflake-specific configurations.

Project Structure
azure/: Contains Terraform configurations for Azure resources, including Virtual Network (VNet), Subnet, Private Endpoint, and Private DNS Zone.

snowflake/: Contains Terraform configurations for Snowflake resources, primarily the Network Policy and its attachment to the Snowflake account.

README.md: This file, providing an overview and instructions.

Prerequisites
Before deploying these Terraform configurations, ensure you have:

Azure Subscription: An active Azure subscription with permissions to create network resources.

Snowflake Account: An Enterprise Edition (or higher) Snowflake account.

Snowflake PrivateLink Enabled: Crucially, you must contact Snowflake Support to enable PrivateLink for your Snowflake account. This is a manual step that Terraform cannot automate.

Snowflake PrivateLink Resource ID: Once PrivateLink is enabled by Snowflake, you need to retrieve the privatelink_azure_resource_id from your Snowflake account by running:

USE ROLE ACCOUNTADMIN;
SELECT KEY, VALUE FROM TABLE(FLATTEN(INPUT => PARSE_JSON(SYSTEM$GET_PRIVATELINK_CONFIG())));

This privatelink_azure_resource_id will be an input variable for the azure module.

Terraform CLI: Installed and configured with Azure credentials.

Snowflake User: A Snowflake user with ACCOUNTADMIN role or sufficient privileges to manage network policies.

Deployment Steps
Follow these steps to deploy the PrivateLink configuration:

Clone the Repository:

git clone https://github.com/your-repo/snowflake-privatelink-terraform.git
cd snowflake-privatelink-terraform

Initialize Terraform:

terraform init

Configure Azure Resources:
Navigate to the azure directory and plan/apply the Azure resources.

cd azure
terraform plan -var="snowflake_private_link_resource_id=<YOUR_SNOWFLAKE_PRIVATE_LINK_RESOURCE_ID>"
terraform apply -var="snowflake_private_link_resource_id=<YOUR_SNOWFLAKE_PRIVATE_LINK_RESOURCE_ID>"

Replace <YOUR_SNOWFLAKE_PRIVATE_LINK_RESOURCE_ID> with the actual value obtained from Snowflake (e.g., sf-azure-privatelink.<your_account_locator>.privatelink.snowflakecomputing.com).

Configure Snowflake Resources:
Navigate to the snowflake directory and plan/apply the Snowflake network policy.

cd ../snowflake
terraform plan -var="snowflake_account_locator=<YOUR_SNOWFLAKE_ACCOUNT_LOCATOR>" \
               -var="snowflake_user=<YOUR_SNOWFLAKE_USER>" \
               -var="snowflake_password=<YOUR_SNOWFLAKE_PASSWORD>" \
               -var="snowflake_allowed_ip_list=[\"<YOUR_VNET_EGRESS_PUBLIC_IP_RANGE>\"]"
terraform apply -var="snowflake_account_locator=<YOUR_SNOWFLAKE_ACCOUNT_LOCATOR>" \
                -var="snowflake_user=<YOUR_SNOWFLAKE_USER>" \
                -var="snowflake_password=<YOUR_SNOWFLAKE_PASSWORD>" \
                -var="snowflake_allowed_ip_list=[\"<YOUR_VNET_EGRESS_PUBLIC_IP_RANGE>\"]"

Replace placeholders with your actual Snowflake account locator, user credentials, and your Azure VNet's public egress IP range (if applicable). If you are strictly enforcing private access and have no public egress, you might leave snowflake_allowed_ip_list as an empty list [] or consult Snowflake for specific PrivateLink IPs to allow.

Post-Deployment Validation
After successful deployment, refer to the "Validation Steps" section in the original PrivateLink setup guide to verify connectivity from your Azure VNet to Snowflake via PrivateLink.
