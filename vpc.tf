
# AWS Region Selection
#provider "aws" {
#  profile = "default"
#  region  = "us-east-1"
#}




# VPC
resource "aws_vpc" "main" {
  cidr_block           = "11.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}