resource "aws_s3_bucket" "remote" {
  bucket = "gangadharam-challa-s3"
}

resource "aws_s3_bucket_versioning" "remote" {
  bucket = aws_s3_bucket.remote.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_instance" "remote" {
  ami = "ami-0a4408457f9a03be3"
  instance_type = "t2.micro"
  key_name = "God"

  tags = {
    name = "today"
  }
}

terraform {
  backend "s3" {
    bucket = "gangadharam-challa-s3"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}