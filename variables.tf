variable "tenant_id" {
    description = "Azure Tenant ID"
    type = string
}
variable "subscription_id" {
    description = "Azure subscription ID"
    type = string
}

variable "azure_region" {
    description = "Azure region"
    type    = string
    default = "East US"
}