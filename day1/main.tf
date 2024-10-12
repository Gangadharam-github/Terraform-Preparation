resource "aws_instance" "dev" {
  ami = "ami-0a4408457f9a03be3"
  instance_type = "t2.micro"
  key_name = "God"

  tags = {
    name = "today"
  }
}