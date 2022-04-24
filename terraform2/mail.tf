provider "aws" {
  profile = "default"
  region = "us-east-1"
}

variable "jenami" {
  default = "ami-04b1b3ba8947d7679"
}
resource "aws_security_group" "allow_http" {
    name = "allow_http"
    description = "Allow HTTP inbound and Outbound traffic"

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

# This will provision EC2 and attached the above Security Group
resource "aws_instance" "my-Jenkins" {
  ami = var.jenami
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  count = 1
  tags = {
    "Name" = "Terraform-Jenkins"
  }
  
}