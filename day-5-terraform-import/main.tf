provider "aws" {
  
}

resource "aws_instance" "import" {
 ami = "ami-0a4408457f9a03be3"
 instance_type= "t2.micro"
 tags = {
    Name ="Import"
 } 
}


