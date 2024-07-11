variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "postgres_user" {}
variable "postgres_password" {}