provider "amazon" {
  region = "ap-south-1"
}

provider "aws" {
  region = "us-est-1"
  alias = "example"
}


resource "aws_s3_bucket" "multiprovider" { 
 bucket = "this-is-my-best-bucket"
 provider = aws.example
}