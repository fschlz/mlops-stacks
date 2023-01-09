# AZURE VARS - try to set with terraform
# export AZURE_RESOURCE_GROUP="thoa"
# export AZURE_RG_LOCATION="westeurope"
# export AZURE_WORKSPACE_NAME=""
# export AZURE_COMPUTE_TARGET_NAME=""
# export AZURE_ENVIRONMENT_NAME=""

# TERRAFORM VARS
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""
export PROJECT_NAME="myproject"

# set subscription
az account set --subscription=$ARM_SUBSCRIPTION_ID

# create service principal
# az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$ARM_SUBSCRIPTION_ID" -n "$PROJECT_NAME-contributor"

export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""

# we can use these credentials to log in as the SP
az logout
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
