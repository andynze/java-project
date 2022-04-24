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

resource "aws_instance" "my-Jenkins" {
  ami = var.jenami
  instance_type = "t2.micro"
  count = 3
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    "Name" = "Terraform-Jenkins"
  }
  
}