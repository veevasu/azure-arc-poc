provider "azurerm"
{
    features{}
    use_oidc    = true
    tenant_id   = var.tenant_id
    subscription_id    = var.subscription_id
}

resource "azurerm_resource_group" "rg"
{ 
    name    = "arc-rg"
    location    = var.azure_region
}

resource "azurerm_virtual_network" "vnet"
{
    name    = "arc_vnet"
    address_space   = ["10.0.0.0/16"]
    location    = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private_link_subnet" {
    name    = "private-link-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes    = ["10.0.1.0/24"]
    private_link_service_network_policies_enabled = false
}

resource "azurerm_storage_account" "storage" {
    name    = "arcstoragedemo"
    resource_group_name = azurerm_resource_group.rg.name
    location    = azurerm_resource_group.rg.location
    account_tier   = "STANDARD"
    account_replication_type    = "LRS"
}

resource "azurerm_storage_container" "dsc" {
    name    = "dsc"
    storage_account_name = azurerm_storage_account.storage.name
    container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_private_link" {
    name    = "storage-private-endpoint"
    resource_group_name = azurerm_resource_group.rg.name
    location    = azurerm_resource_group.rg.location
    subnet_id   = azurerm_subnet.private_link_subnet.id

    private_service_connection {
        name    = "storage-private-connection"
        private_connection_resource_id  = azurerm_storage_account.storage.id
        subresources_names  = ["blob"]
        is_manual_connecion = false
    }    
}