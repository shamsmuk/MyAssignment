resource "azurerm_resource_group" "example" {
  name     = "mukit_rg_group"
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

resource "azurerm_sql_server" "primary" {
  name                         = "sql-primary"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = data.azurerm_key_vault_secret.SQLpassword.value
}
resource "azurerm_sql_server" "secondary" {
  name                         = "sql-secondary"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = "northeurope"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = data.azurerm_key_vault_secret.SQLpassword.value
}

resource "azurerm_sql_database" "personal_db" {
  name                = "personal_db"
  resource_group_name = azurerm_sql_server.primary.resource_group_name
  location            = azurerm_sql_server.primary.location
  server_name         = azurerm_sql_server.primary.name
}
resource "azurerm_sql_failover_group" "example" {
  name                = "example-failover-group"
  resource_group_name = azurerm_sql_server.primary.resource_group_name
  server_name         = azurerm_sql_server.primary.name
  databases           = [azurerm_sql_database.personal_db.id]
  partner_servers {
    id = azurerm_sql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
output "vault_uri" {
  value = data.azurerm_key_vault.example.vault_uri
}
output "secret_value" {
  value = data.azurerm_key_vault_secret.SQLpassword.value
}