variable "access_key" {}

variable "secret_key" {}

variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "vpc_cidr" {
  type    = "string"
  default = "10.119.26.0/23"
}

variable "AppID" {
  description = "What is the CSI App ID that will be located in this VPC?"
  type = "string"
}

variable "AppName" {
  description = "Application user friendly name - (no sapce and 10 characters max)"
  type = "string"
}

variable "BillingID" {
  description = "What is the CSI Biling Profile number to be used with the App ID that will be located in this VPC?"
  type = "string"
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN."
}

variable "domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided"
  type = "list"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Key/value tags to assign to all AWS resources"
}
