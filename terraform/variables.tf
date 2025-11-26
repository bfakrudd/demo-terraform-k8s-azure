variable "location" {
  description = "Azure region"
  default     = "eastus"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  default     = "1.28.3"
}