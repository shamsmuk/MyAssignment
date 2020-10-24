variable "location" {
  default = "uksouth"
}
variable "tenant_id" {
   type = string
   default = "$Env:TF_VAR_tenant_id"
}