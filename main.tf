

provider "aws" {
  region = var.aws_region
}



# data "terraform_remote_state" "remote" {
#   backend = "remote"
#   config {
#     hostname     = "app.terraform.io"
#     organization = var.remote_org
#     #token        = "${var.team_token}"

#     workspaces {
#       name = var.remote_workspace
#     }
#   }
# }

data "terraform_remote_state" "remote" {
  backend = "remote"

  config = {
    organization = var.remote_org

    workspaces = {
      name = var.remote_workspace
    }
  }
}


# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = var.remote_org

#     workspaces {
#       name = var.remote_workspace
#     }
#   }
# }



module "tfe" {
  source = "git@github.com:joestack/is-terraform-aws-tfe-standalone.git"

  friendly_name_prefix       = var.name_prefix

  
  tfe_bootstrap_bucket          = data.terraform_remote_state.remote.tfe_bootstrap_bucket
  tfe_license_filepath          = "s3://${data.terraform_remote_state.remote.tfe_bootstrap_bucket}/tfe-license.rli"
  tfe_hostname                  = "${var.hostname}.${var.dns_zone}"
  console_password              = "aws_secretsmanager"
  enc_password                  = "aws_secretsmanager"
  aws_secretsmanager_secret_arn = data.terraform_remote_state.remote.aws_secret_arn
  
  vpc_id                     = data.terraform_remote_state.remote.vpc_id
  alb_subnet_ids             = data.terraform_remote_state.remote.alb_subnet_ids # private subnet IDs
  ec2_subnet_ids             = data.terraform_remote_state.remote.ec2_subnet_ids # private subnet IDs
  rds_subnet_ids             = data.terraform_remote_state.remote.rds_subnet_ids # private subnets IDs
  load_balancer_is_internal  = true
  route53_hosted_zone_public = var.dns_zone

  ssh_key_pair = var.key
  rds_master_password = var.rds_password

}

