provider "aws" {
  region = "us-east-2"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 22
}

resource "aws_instance" "terraform-ssh-ec2" {
  ami           = "ami-0aeb7c931a5a61206"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg-instance.id]
  key_name = "user-ec2"


  tags = {
    Name = "Terraform-ssh-ec2"
  }
  }

  resource "aws_security_group" "sg-instance" {
    name = "terraform-ssh-ec2-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value       = aws_instance.terraform-ssh-ec2.public_ip
  description = "The public IP address of the ec2 instance"
}


