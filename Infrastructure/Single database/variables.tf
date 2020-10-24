# variable "serviceprinciple_id" {
    #type = string
   # default = "$Env:TF_VAR_client_id"
# }

# variable "serviceprinciple_key" {
   #type = string
    #default = "$Env:TF_VAR_client_secret"
# }

variable "tenant_id" {
   type = string
    default = "$Env:TF_VAR_tenant_id"
}

variable "subscription_id" {
   type = string
    default = "$Env:TF_VAR_subscription_id"
}

variable "location" {
  default = "uksouth"
}