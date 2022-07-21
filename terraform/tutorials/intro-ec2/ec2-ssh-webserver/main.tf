provider "aws" {
  region = "us-east-2"
}


variable "http_port" {
  description = "HTTP server port"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}


variable "ami_id" {

  description = "ami id"
  type    = string
  default = "ami-02f3416038bdb17fb"
  # 
}

resource "aws_instance" "terraform-ssh-http-ec2" {
   ami           = var.ami_id     
   instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.sg-instance.id]
   key_name = "user-ec2"

   user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.http_port} &
            EOF

   tags = {
      Name = "Terraform-ssh-http-instance"
    }
  }

  resource "aws_security_group" "sg-instance" {
    name = "terraform-ssh-http-sg"

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value       = aws_instance.terraform-ssh-http-ec2.public_ip
  description = "The public IP address of the web server and ec2 instance"
}


