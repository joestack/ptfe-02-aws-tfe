
output "tfe_url" {
  value = module.tfe.tfe_url
}

output "tfe_admin_console_url" {
  value = module.tfe.tfe_admin_console_url
}

output "vpc" {
    value = data.terraform_remote_state.remote.vpc_id
}

output "alb_subnets" {
    value = data.terraform_remote_state.remote.alb_subnet_ids
}