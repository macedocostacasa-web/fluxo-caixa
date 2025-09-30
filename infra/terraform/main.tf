terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}
provider "azurerm" { features {} }

variable "name" { type = string }
variable "env"  { type = string  default = "dev" }
variable "location" { type = string default = "eastus" }

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}-${var.env}-core"
  location = var.location
}

// TODO: modules for servicebus, cosmos, redis etc. (skeleton)