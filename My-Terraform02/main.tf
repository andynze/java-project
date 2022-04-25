provider "aws" {
  profile = "default"
  region = "us-east-1"
}

variable "jenami" {
  default = "ami-0fb08e0768d724917"
}

# 1. Create a VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create Custom Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

    route {
      ipv6_cidr_block        = "::/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "prob-subnet"
    }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  

  tags = {
    Name = "allow_web"
  }
}
# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
# 8. Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw] 
}

# S3 Bucket remote statefile location
terraform {
  backend "s3" {
    bucket = "nzeka-stf-bucket"
    key    = "devops2/state.tfstate"
    region = "us-east-1"
  }
}
resource "aws_instance" "Jenkins" {
    ami = var.jenami
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    key_name = "DellDevOpsKey"
    vpc_security_group_ids =  ["sg-0a107b205e6e0f859"] #Jenkins-Vprofile-SG
    tags = {
     "Name" = "Jenkins-Server"
   }
}
resource "aws_instance" "ubuntu18_04_01" {
   ami = "ami-07bb02ebf0db77e8a"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    key_name = "DellDevOpsKey"
    vpc_security_group_ids =  ["sg-0d5fbb733b7690801"] #Nexus-Vprofile-SG
    tags = {
        Name = "Nexus-Server"
    }  
}
resource "aws_instance" "ubuntu18_04_02" {
    ami = "ami-01285be225de9a0de"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    vpc_security_group_ids =  ["sg-0b21765a2d2c24833"] #Sonarqube-Vprofile-SG
    key_name = "DellDevOpsKey"
    tags = {
        Name = "SonarQube-Server"
    }  
}
#resource "aws_instance" "ubuntu18_04_03" {
#   ami = "ami-01eda8eaca479cd7c"
#    instance_type = "t2.small"
#    availability_zone = "us-east-1a"
#    vpc_security_group_ids =  ["sg-05486d51818b61bd5"] #vprofile-app-TC-staging-SG
#    key_name = "DellDevOpsKey"
#    tags = {
#        Name = "Tomcat-Server"
#    }  
#}

#Update to git


