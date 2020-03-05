
# creation du security group

resource "azurerm_network_security_group" "NSG_prod" {
    name = "NSG_prod"
    location = "${var.location}"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }

    security_rule {

        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }


    security_rule {

        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }

     security_rule {

        name                       = "jenkins"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        
    }
    security_rule {

        name                       = "Mango"
        priority                   = 1005
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "27017"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }
}



# creation d'une adresse IP Public

resource "azurerm_public_ip" "IP_prod" {
    name                         = "IP_prod"
    location                     = "${var.location}"
    resource_group_name          = "${data.azurerm_resource_group.RGapp.name}"
    allocation_method            = "Static"
    
}

# création d'une carte reseau   

resource "azurerm_network_interface" "NIC_prod" {
    name                      = "NIC_prod"
    location                  = "${var.location}"
    resource_group_name       = "${data.azurerm_resource_group.RGapp.name}"
    network_security_group_id = "${azurerm_network_security_group.NSG_prod.id}"   

    ip_configuration {
        name                          = "ipconfprod"
        subnet_id                     = "${azurerm_subnet.subnet_prod.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.2.5"
        public_ip_address_id          = "${azurerm_public_ip.IP_prod.id}"
    }

}

# création d'une VM

resource "azurerm_virtual_machine" "prod" {

        name                  = "VMprod"
        location              = "${var.location}"
        resource_group_name   = "${data.azurerm_resource_group.RGapp.name}"
        network_interface_ids = ["${azurerm_network_interface.NIC_prod.id}"]
        vm_size               = "Standard_B1ms"

        storage_os_disk {
            name              = "myOsDisk5"
            caching           = "ReadWrite"
            create_option     = "FromImage"
            managed_disk_type = "Standard_LRS"

    }
        storage_image_reference {
            publisher = "OpenLogic"
            offer     = "CentOS"
            sku       = "7.6"
            version   = "latest"

        }
        
        os_profile {
            computer_name  = "MounaSylvainVM4"
            admin_username = "MounaSylvain"
        }

        os_profile_linux_config {
            disable_password_authentication = true
            ssh_keys {
                path     = "/home/MounaSylvain/.ssh/authorized_keys"
                key_data = "${var.key_data}"

        }

    }
}
