provider "aws" {
  
}

data "aws_ami" "amazon" {
  most_recent = true
  owners=["amazon"]

  filter {
    name = "name"
    values = ["amazon-ra-bujji"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

}


resource "aws_instance" "dependency" {
  ami = data.aws_ami.amazon
  instance_type = "t2.micro"
  key_name = "God"

  tags = {
    name = "dependency"
  }
}

