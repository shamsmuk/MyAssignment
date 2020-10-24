provider "azurerm" {
  version = "=2.20.0"

  subscription_id = var.subscription_id
  #client_id       = var.serviceprinciple_id
 # client_secret   = var.serviceprinciple_key
  tenant_id       = var.tenant_id

  features {}
}
locals {
  tags = {
    "managed"     = "terraformed"
    "owner"       = "mukitshams@gmail.com"
    "environment" = "learning"
  }
}

module "my_sqldb" {
  source                = "./modules/sqldb"
  tenant_id       = var.tenant_id
  #subscription_id = var.subscription_id
  #serviceprinciple_id   = var.serviceprinciple_id
  #serviceprinciple_key  = var.serviceprinciple_key
  location              = var.location
  
   

}
output "vault_uri" {
  value = module.my_sqldb.vault_uri
}
output "secret_value" {
  value = module.my_sqldb.secret_value
}