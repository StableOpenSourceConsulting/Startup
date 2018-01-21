# Terraform script to build 3x EC2 instances from an AMI in Dublin
provider "aws" {
access_key = "AKIAXXXXXXXXXXGXXZMEA"
secret_key = "MDeGUAxxxxxxxxxxJIBKNEfcr/e59ixxxxxxxxxITUeX"
region = "eu-west-1"
}
resource "aws_instance" "standard-centos7-swap" {
ami = "ami-922cbbed" 
instance_type = "t2.micro"
count = "3"
security_groups = ["Centos7-default-terraform-build-ssh-only"]
tags {
Name = "forum-server-byTerraform"
   }
}
