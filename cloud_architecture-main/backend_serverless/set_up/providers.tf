provider "aws" {
  region = "eu-west-1"
  profile = "default@admin"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}