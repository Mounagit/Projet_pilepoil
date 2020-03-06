#! /usr/bin

# Commandes terraform permmettant de créer les machines Master et Slave

terraform init
terraform plan -var-file="main.tfvars" -var-file="backend.tfvars"
terraform apply -var-file="main.tfvars" -var-file="backend.tfvars"

