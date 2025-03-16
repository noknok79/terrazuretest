# Variable for the resource group name
variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be deployed"
  type        = string
}

# Variable for the location
variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
  default     = "East US" # Default location
}

# Variable for the AKS cluster name
variable "aks_cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster"
  type        = string
}

# Variable for the number of nodes in the default node pool
variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 3 # Default node count
}

# Variable for the VM size of the nodes in the default node pool
variable "node_vm_size" {
  description = "The size of the Virtual Machines in the default node pool"
  type        = string
  default     = "Standard_DS2_v2" # Default VM size
}