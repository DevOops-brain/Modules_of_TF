terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      # The variables 'project_name' and 'environment' must be set in `.tfvars` if used with distributed environment structure.
      ProjectName = var.project_name
      Environment = var.environment
      CreatedBy   = "Terraform"
    }
  }
}