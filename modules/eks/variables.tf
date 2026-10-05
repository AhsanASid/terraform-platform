variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.31"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the EKS cluster and worker nodes"
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for the node group"
  default     = ["t3.medium"]
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 2
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
