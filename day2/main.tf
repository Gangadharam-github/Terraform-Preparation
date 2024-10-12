resource "aws_instance" "name" {
  ami= var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
 
  tags = {
    name = "ec2_day2"

  }
}


#resource "aws_s3_bucket" "name" {
 # bucket = "hbkabvkadbvjabdvbaldbv"
#}