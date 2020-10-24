resource "azurerm_resource_group" "rg_mukit_db" {
  name     = "rg_mukit_db"
  location = var.location
}
# We need to create a key vault prior to run this step.
# Create a key vault:
# New-AzureRmKeyVault -VaultName 'mukitkeyvault1' -ResourceGroupName 'rg_mukit_keyvault' -Location 'uksouth'
# add a secret to Azure Key Vault:
# $secretvalue = ConvertTo-SecureString 'XXX_Strong_Password' -AsPlainText -Force
# $secret = Set-AzureKeyVaultSecret -VaultName 'mukitkeyvault1' -Name 'SQLpassword' -SecretValue $secretvalue
# We can also create key vault by using Azure Portal

data "azurerm_key_vault" "example" {
  name                = "mukitkeyvault1"
  resource_group_name = "rg_mukit_keyvault"
}


data "azurerm_key_vault_secret" "SQLpassword" {
  name         = "SQLpassword"
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_sql_server" "mukitsqlsvr1" {
    name                         = "mukitsqlsvr1"
    resource_group_name          =  azurerm_resource_group.rg_mukit_db.name
    location                     =  azurerm_resource_group.rg_mukit_db.location
    version                      = "12.0"
    administrator_login          = "mukitshams"
    administrator_login_password = data.azurerm_key_vault_secret.SQLpassword.value
    
}

resource "azurerm_sql_firewall_rule" "myfirewallrule" {
  name                = "AlllowAzureServices"
  resource_group_name = azurerm_resource_group.rg_mukit_db.name
  server_name         = azurerm_sql_server.mukitsqlsvr1.name
  start_ip_address    = "80.47.113.9"
  end_ip_address      = "80.47.113.9"
}
resource "azurerm_sql_database" "mukitsqldb1" {
  name                             = "mukitsqldb1"
  resource_group_name              = azurerm_resource_group.rg_mukit_db.name
  location                         = azurerm_resource_group.rg_mukit_db.location
  server_name                      = azurerm_sql_server.mukitsqlsvr1.name
  edition                          = "Standard"
  requested_service_objective_name = "S0"
}

output "vault_uri" {
  value = data.azurerm_key_vault.example.vault_uri
}
output "secret_value" {
  value = data.azurerm_key_vault_secret.SQLpassword.value
}