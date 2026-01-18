variable "location" {
  description = "Azure region"
  default     = "westus"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  default     = "1.33.3"
}

variable "resource_group_name" {
  description = "existing resource group name for AKS cluster"
  default     = "1-052519e7-playground-sandbox"
}
