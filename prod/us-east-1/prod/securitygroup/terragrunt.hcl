locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group.git"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

#
dependency "vpc" {
  config_path = "../vpc"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name                = "secgroup-${local.env}"
  description         = "demo de grupo de seguridad"
  vpc_id              = dependency.vpc.outputs.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
}