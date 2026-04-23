terraform {
  required_version = ">= 1.13.3, < 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
  backend "s3" {
    bucket       = "baho-backup-bucket"
    region       = "us-west-2"
    key          = "EKS-ArgoCD-AWS-LB-Controller-Terraform/vpc-ec2.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws-region
}
