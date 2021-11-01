locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../securitygroup"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration abov

inputs = { 
  name                   = "ec2-${local.env}"
  instance_count         = 1
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [dependency.sg.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.private_subnets[1]

  tags = {
    Terraform   = "true"
    Environment = "${local.env}"
  }
}

#vamos los
