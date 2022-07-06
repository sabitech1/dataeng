provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "tf-example" {
  ami           = "ami-0aeb7c931a5a61206"
  instance_type = "t3.micro"

  associate_public_ip_address = "false"

  tags = {
    Name = "Terraform-example"
  }
  }


