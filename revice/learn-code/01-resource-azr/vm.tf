# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.17.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "b14c026b-ae19-4ae1-b201-4c9c8bbe61ad"
  tenant_id = "56a8a143-d9fe-43da-a019-4bbc155c2a80"
}
variable "prefix" {
  default = "devops"
}

resource "azurerm_resource_group" "devops-test" {
  name     = "${var.prefix}-resources"
  location = "Central India"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.devops-test.location
  resource_group_name = azurerm_resource_group.devops-test.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.devops-test.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.devops-test.location
  resource_group_name = azurerm_resource_group.devops-test.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create the Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.devops-test.location
  resource_group_name   = azurerm_resource_group.devops-test.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "devops"
    admin_username = "ubuntu"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "development"
  }
}