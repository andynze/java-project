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

# Defining Variable
variable "amazon_img" {
    default = "ami-0f9fc25dd2506cf6d" 
}

variable "ec2-size" {
    default = "t2.micro" 
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" = "my_vpc"
    }
}

resource "aws_subnet" "private_sub1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.128/26"
    tags = {
      "Name" = "private_sub1"
    }
}

# This will provision Security Group
resource "aws_security_group" "allow_http" {
    name = "allow_http"
    description = "Allow HTTP inbound and Outbound traffic"
    vpc_id = aws_vpc.my_vpc.id

ingress  {
      cidr_blocks = [ "75.43.138.207/32" ]
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
}

ingress  {
      cidr_blocks = [ "75.43.138.207/32" ]
      from_port = 22
      to_port = 22
      protocol = "tcp"
} 
    egress   {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 0
      to_port = 0
      protocol = "-1"
    } 
    tags = {
      "Name" = "allow_http"
    }
}

resource "aws_instance" "Server01" {
    ami = var.amazon_img
    instance_type = var.ec2-size
    vpc_security_group_ids = [aws_security_group.allow_http.id]
    subnet_id = aws_subnet.private_sub1.id
    count = 1
    key_name = "DellDevOpsKey"
    tags = {
      "Name" = "MyServer01"
    }  
}