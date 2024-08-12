provider "aws" {
  
}

resource "aws_instance" "name" {
  ami= var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
 
  tags = {
    name = "ec2_day2"

  }
}
