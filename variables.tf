variable "remote_workspace" {
  default = "ptfe-01-lic-bucket"
}

variable "remote_org" {
  default = "JoeStack"
}

variable "name_prefix" {
  default = "joestack"
}

variable "dns_zone" {
  default = "joestack.xyz"
}

variable "hostname" {
  default = "terraform"
}

variable "key" {
  default = "joestack"
}

variable "rds_password" {
  default = "you_are_mad_not_to_change"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "os_distro" {}

variable "rds_skip_final_snapshot" {}

variable "bastion_host" {}