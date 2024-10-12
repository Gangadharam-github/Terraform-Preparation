resource "aws_vpc" "dev" {   #this is for vpc
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "cust_vpc"
  }

}

resource "aws_subnet" "dev" {     #this is for subnet
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"

}
resource "aws_internet_gateway" "dev" {    #this is for internet gateway
  vpc_id = aws_vpc.dev.id
  
}

resource "aws_route_table" "dev" {    #this is for edit route table
  vpc_id = aws_vpc.dev.id
  route  {
    cidr_block = "0.0.0.0/"
    gateway_id= aws_internet_gateway.dev.id

  }
}

resource "aws_route_table_association" "dev" {     #this si for associaton
  subnet_id = aws_subnet.dev.id
  route_table_id = aws_route_table.dev.id
}


resource "aws_security_group" "allow" {     # this s for security group
  name = "allow"
  vpc_id = aws_vpc.dev.id
  tags = {
    name = "devsg"
  
  }

  ingress  {
    description =" this is inbound security group"
    from_port =22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_instance" "hello"  {   # this is for creating the instance
  ami = var.ami_id
  instance_type =var.instance_type
  key_name = var.key_name

tags = {
  name = "hello"
}
}





resource "aws_s3_bucket" "remote" {
  bucket = "hello-thisis-hello-bucket"
  depends_on = [ aws_instance.hello ] # this is dependece block
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.remote.id
  versioning_configuration {     # this is or system vsersitonining
    status = "Enabled"
  }
}