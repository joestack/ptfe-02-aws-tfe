

provider "aws" {
  region = var.aws_region
}


data "terraform_remote_state" "remote" {
  backend = "remote"

  config = {
    organization = var.remote_org

    workspaces = {
      name = var.remote_workspace
    }
  }
}


module "tfe" {
  source = "git@github.com:joestack/js-terraform-aws-tfe-standalone.git"

  friendly_name_prefix       = var.name_prefix
  common_tags = {
    "App"               = "TFE"
    "Environment"       = "Production"
    "Is_Secondary"      = "False"
    "Owner"             = "Joern"
    "Provisioning_Tool" = "Terraform"
  }

  
  tfe_bootstrap_bucket          = data.terraform_remote_state.remote.outputs.tfe_bootstrap_bucket
  #tfe_license_filepath          = "s3://data.terraform_remote_state.remote.outputs.tfe_bootstrap_bucket/tfe-license.rli"
  tfe_license_filepath          = "s3://${data.terraform_remote_state.remote.outputs.tfe_bootstrap_bucket}/tfe-license.rli"
  tfe_hostname                  = "${var.hostname}.${var.dns_zone}"
  console_password              = "aws_secretsmanager"
  enc_password                  = "aws_secretsmanager"
  aws_secretsmanager_secret_arn = data.terraform_remote_state.remote.outputs.aws_secret_arn
  
  vpc_id                     = data.terraform_remote_state.remote.outputs.vpc_id
  alb_subnet_ids             = data.terraform_remote_state.remote.outputs.alb_subnet_ids # private subnet IDs
  ec2_subnet_ids             = data.terraform_remote_state.remote.outputs.ec2_subnet_ids # private subnet IDs
  rds_subnet_ids             = data.terraform_remote_state.remote.outputs.rds_subnet_ids # private subnets IDs
  load_balancer_is_internal  = false # was true before and I got no access to the node
  route53_hosted_zone_public = var.dns_zone
  os_distro                  = var.os_distro
  rds_skip_final_snapshot    = var.rds_skip_final_snapshot
  bastion_host               = var.bastion_host

  ssh_key_pair = var.key
  rds_master_password = var.rds_password

  ingress_cidr_alb_allow     = ["0.0.0.0/0"]
  ingress_cidr_console_allow = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # my workstation IP, IT admins workstation subnet
  ingress_cidr_ec2_allow     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # my workstation IP, my Bastion host IP 

}

