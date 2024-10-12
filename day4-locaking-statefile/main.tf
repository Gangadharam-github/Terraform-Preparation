resource "aws_s3_bucket" "ganga" {
  bucket = "gangu-123-bucket"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.ganga.id
  versioning_configuration {
    status = "Enabled"
  }
}

#terraform {
  # backend "s3" {
      # key = "terraform.tfstate"
     # region = "ap-south-1"
     # dynamodb_table = "terraform-loc"
     ##} 
#}