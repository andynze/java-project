provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "Jenkins" {
    ami = "ami-04b1b3ba8947d7679"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    key_name = "DellDevOpsKey"
    vpc_security_group_ids =  ["sg-0a107b205e6e0f859"]
    tags = {
     "Name" = "Jenkins-Server"
   }
}
resource "aws_instance" "ubuntu18_04_01" {
   ami = "ami-07bb02ebf0db77e8a"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    key_name = "DellDevOpsKey"
    vpc_security_group_ids =  ["sg-0d5fbb733b7690801"]
    tags = {
        Name = "Nexus-Server"
    }  
}
resource "aws_instance" "ubuntu18_04_02" {
    ami = "ami-01285be225de9a0de"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    vpc_security_group_ids =  ["sg-0b21765a2d2c24833"]
    key_name = "DellDevOpsKey"
    tags = {
        Name = "SonarQube"
    }  
}