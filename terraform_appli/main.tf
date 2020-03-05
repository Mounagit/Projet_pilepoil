
# création du ressource group
data "azurerm_resource_group" "RGapp" {
    name = "${var.nameRG}" 
    #location = "${var.location}"
}

# création du subnet 
data "azurerm_subnet" "subnet_test" {
    name = "subnet_test"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    virtual_network_name = "${data.azurerm_virtual_network.my_AzureVnet.name}"
    #address_prefix = "10.0.3.0/24"
}

# création du subnet 
data "azurerm_subnet" "subnet_prod" {
    name = "subnet_prod"
    resource_group_name = "${data.azurerm_resource_group.RGapp.name}"
    virtual_network_name = "${data.azurerm_virtual_network.my_AzureVnet.name}"
    #address_prefix = "10.0.2.0/24"

}


##### Pour la VM test


# creation du security group

resource "azurerm_network_security_group" "NSG_test" {
    name = "NSG_test"
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

        name                       = "Mango"
        priority                   = 1004
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

resource "azurerm_public_ip" "IP_test" {
    name                         = "IP_test"
    location                     = "${var.location}"
    resource_group_name          = "${data.azurerm_resource_group.RGapp.name}"
    allocation_method            = "Static"
    
}

# création d'une carte reseau   

resource "azurerm_network_interface" "NIC_test" {
    name                      = "NIC_test"
    location                  = "${var.location}"
    resource_group_name       = "${data.azurerm_resource_group.RGapp.name}"
    network_security_group_id = "${azurerm_network_security_group.NSG_test.id}"   

    ip_configuration {
        name                          = "IPconftest"
        subnet_id                     = "${data.azurerm_subnet.subnet_test.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.3.17"
        public_ip_address_id          = "${azurerm_public_ip.IP_test.id}"
    }

}

# création de du serveur test

resource "azurerm_virtual_machine" "Test" {

        name                  = "VMTest"
        location              = "${var.location}"
        resource_group_name   = "${data.azurerm_resource_group.RGapp.name}"
        network_interface_ids = ["${azurerm_network_interface.NIC_test.id}"]
        vm_size               = "Standard_B1ms"

        storage_os_disk {
            name              = "myOsDisk3"
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
            computer_name  = "MounaSylvainVM3"
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


########## Pour la VM Prod



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
        subnet_id                     = "${data.azurerm_subnet.subnet_prod.id}"
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

##########  Pour la BDD test



# creation du security group

resource "azurerm_network_security_group" "NSG_BDDtest" {
    name = "NSG_BDDtest"
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

        name                       = "Mango"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "27017"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }
}




# création d'une carte reseau   

resource "azurerm_network_interface" "NIC_BDDtest" {
    name                      = "NIC_BDDtest"
    location                  = "${var.location}"
    resource_group_name       = "${data.azurerm_resource_group.RGapp.name}"
    network_security_group_id = "${azurerm_network_security_group.NSG_test.id}"   

    ip_configuration {
        name                          = "IPconfBDDtest"
        subnet_id                     = "${data.azurerm_subnet.subnet_test.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.3.6"
    
    }

}

# création de du serveur test

resource "azurerm_virtual_machine" "BDDTest" {

        name                  = "VMBDDTest"
        location              = "${var.location}"
        resource_group_name   = "${data.azurerm_resource_group.RGapp.name}"
        network_interface_ids = ["${azurerm_network_interface.NIC_BDDtest.id}"]
        vm_size               = "Standard_B1ms"

        storage_os_disk {
            name              = "myOsDisk4"
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



######## Pour la BDD prod



# creation du security group

resource "azurerm_network_security_group" "NSG_BDDprod" {
    name = "BDDNSG_prod"
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



# création d'une carte reseau   

resource "azurerm_network_interface" "NIC_BDDprod" {
    name                      = "NIC_BDDprod"
    location                  = "${var.location}"
    resource_group_name       = "${data.azurerm_resource_group.RGapp.name}"
    network_security_group_id = "${azurerm_network_security_group.NSG_BDDprod.id}"   

    ip_configuration {
        name                          = "ipconfBDDprod"
        subnet_id                     = "${data.azurerm_subnet.subnet_prod.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.2.6"
       
    }

}

# création d'une VM

resource "azurerm_virtual_machine" "BDDprod" {

        name                  = "VMBDDprod"
        location              = "${var.location}"
        resource_group_name   = "${data.azurerm_resource_group.RGapp.name}"
        network_interface_ids = ["${azurerm_network_interface.NIC_BDDprod.id}"]
        vm_size               = "Standard_B1ms"

        storage_os_disk {
            name              = "myOsDisk6"
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
            computer_name  = "MounaSylvainVM5"
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

