variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Primary region for resources"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone for bastion host"
  type        = string
  default     = "europe-west1-b"
}

variable "zones" {
  description = "Zones for multi-zone cluster"
  type        = list(string)
  default     = ["europe-west1-d", "europe-west1-b", "europe-west1-c"]
}

variable "subnet_cidr" {
  description = "CIDR range for subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-micro"
}

variable "bastion_machine_type" {
  description = "Machine type for bastion host"
  type        = string
  default     = "e2-micro"
}
