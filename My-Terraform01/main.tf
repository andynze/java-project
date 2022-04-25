provider "aws" {
    profile = "default"
    region = "us-east-1"
}

# S3 Bucket remote statefile location
terraform {
  backend "s3" {
    bucket = "nzeka-stf-bucket"
    key    = "devops/state.tfstate"
    region = "us-east-1"
  }
}

# resource "aws_vpc" "my_vpc" {
#     cidr_block = "10.0.0.0/16"
#     instance_tenancy = "default"
#     tags = {
#       "Name" = "my_vpc"
#     }
# }

# resource "aws_subnet" "private_sub1" {
#     vpc_id = aws_vpc.my_vpc.id
#     cidr_block = "10.0.0.128/26"
#     tags = {
#       "Name" = "private_sub1"
#     }
# }

module "mod-sg" {
  source = "./sec-group/"
  
}
resource "aws_instance" "Server01" {
    ami = var.amazon_img
    instance_type = var.ec2-size
    vpc_security_group_ids = [module.mod-sg.sg-out]
   # subnet_id = aws_subnet.private_sub1.id
    count = 1
    key_name = "DellDevOpsKey"
    tags = {
      "Name" = "MyServer01"
    }  
}