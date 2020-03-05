
# création du ressource group
data "azurerm_resource_group" "RGapp" {
    name = "${var.nameRG}"
    location = "${var.location}" 
}

# création du Azure Vnet 

data "azurerm_virtual_network" "my_AzureVnet" {
    name = "${var.nameVnet}" 
    address_space = [ "10.0.0.0/16" ]
    location = "${var.location}"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    
}

# création du subnet 
data "azurerm_subnet" "subnet_test" {
    name = "subnet_test"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    virtual_network_name = "${data.azurerm_virtual_network.my_AzureVnet.name}"
    address_prefix = "10.0.3.0/24"
}


# création du subnet 
data "azurerm_subnet" "subnet_prod" {
    name = "subnet_prod"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    virtual_network_name = "${data.azurerm_virtual_network.my_AzureVnet.name}"
    address_prefix = "10.0.2.0/24"

}
