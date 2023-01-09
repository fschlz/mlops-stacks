# zenml setup
export STACK_PROFILE="azureml-mlflow"
export STEP_OPERATOR_NAME="thoa"

# azure credentials
export SUBSCRIPTION_ID=$(terraform output subscription-id)
export CLIENT_ID=$(terraform output service-principal-client-id)
export CLIENT_SECRET=$(terraform output service-principal-client-secret)
export TENANT_ID=$(terraform output service-principal-tenant-id)

# azure resource group
export RESOURCE_GROUP=$(terraform output resource-group-name)
export REGION=$(terraform output resource-group-location)

# azure storage
export AZURE_STORAGE_CONNECTION_STRING=$(terraform output storage-account-connection-string)
export CONTAINER_PATH=$(terraform output blobstorage-container-path)

# azureml
export WORKSPACE_NAME=$(terraform output azureml-workpsace-name)
export CLUSTER_NAME=$(terraform output azureml-compute-cluster-name)
export KEY_VAULT_NAME=$(terraform output key-vault-name)

# azure mlflow
export TRACKING_URI=$(terraform output mlflow-tracking-URL)

TOKEN="$(curl -i -X POST \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" \
  -d "grant_type=client_credentials" \
  -d "resource=https://management.azure.com" \
  "https://login.microsoftonline.com/${TENANT_ID}/oauth2/token"
  | jq -r .access_token)"

echo $TOKEN

zenml clean
zenml init

zenml artifact-store register azure_store \
    --flavor=azure \
    --path=$CONTAINER_PATH

zenml secrets-manager register azure_secrets_manager \
    --flavor=azure \
    --key_vault_name=$KEY_VAULT_NAME

zenml experiment-tracker register azureml_mlflow_experiment_tracker --flavor=mlflow --tracking_uri=$TRACKING_URI --tracking_token=$TOKEN

zenml step-operator register azureml \
    --flavor=azureml \
    --subscription_id=$SUBSCRIPTION_ID \
    --resource_group=$RESOURCE_GROUP\
    --workspace_name=$WORKSPACE_NAME \
    --compute_target_name=$CLUSTER_NAME

zenml stack register azureml_stack \
    -o default \
    -a azure_store \
    -s azureml \
    -x azure_secrets_manager \
    -e azureml_mlflow_experiment_tracker \
    --set

zenml step-operator register $STEP_OPERATOR_NAME \
    --flavor=azureml \
    --subscription_id=$AZURE_SUBSCRIPTION_ID \
    --resource_group=$AZURE_RESOURCE_GROUP \
    --workspace_name=$AZURE_WORKSPACE_NAME \
    --compute_target_name=$AZURE_COMPUTE_TARGET_NAME \
    --environment_name=$AZURE_ENVIRONMENT_NAME \
# only pass these if using Service Principal Authentication
#   --tenant_id=<TENANT_ID> \
#   --service_principal_id=<SERVICE_PRINCIPAL_ID> \
#   --service_principal_password=<SERVICE_PRINCIPAL_PASSWORD> \

# Add the step operator to the active stack
zenml stack update -s $STEP_OPERATOR_NAME