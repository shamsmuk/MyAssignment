Create Service Principal:

It is best practice to create a seperate Service principal account for Terraform. Step by step processes are below:

# login to Azure
	- az login
	store the tenant_id to the variable $TENTANT_ID=<tenant_id>
# view and select the subscription id to the variable
	- az account list -o table
		$SUBSCRIPTION=<id>
# Now create the Service principal
	SP_JSON=$(az ad sp create-for-rbac --skip-assignment --name terraform -o json)
# Keep the "appId" and "password" for later use.
	SERVICE_PRINCIPAL_ID=$(echo $P_JSON | jq -r '.appId')
	SERVICE_PRINCIPAL_KEY=$(echo $SP_JSON | jq -r '.password')

# Grant contributor role over the subscription to our service principal

	az role assignment create --assignee $SERVICE_PRINCIPAL \
	--scope "/subscriptions/$SUBSCRIPTION" \
	--role Contributor