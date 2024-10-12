#need to crete the vpc
resource "aws_vpc" "Gangadharam" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "cust-vpc"
  }
}

#create the subnet
resource "aws_subnet" "Gangadharam" {
  vpc_id = aws_vpc.Gangadharam.id
  cidr_block = "10.0.0.0/24"
  tags = {
    name ="cust-subnet"
  }
}

#create internetgateaway
resource "aws_internet_gateway" "Gangadharam" {
  vpc_id = aws_vpc.Gangadharam.id
  tags = {
    name = "IG"
  }
}

#route tables 
resource "aws_route_table" "Gangadharam" {
  vpc_id = aws_vpc.Gangadharam.id
  tags = {
    name = "cust-route"
  }
}

#rote the trafic to ig to RT #edit routs
resource "aws_route" "name" {
  route_table_id = aws_route_table.Gangadharam.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Gangadharam.id
}
#route the network to RT to sibnet   association
resource "aws_route_table_association" "Gangadharam" {
  subnet_id = aws_subnet.Gangadharam.id
  route_table_id = aws_route_table.Gangadharam.id

}

#create a security groups
resource "aws_security_group" "Gangadharam" {


  vpc_id      = aws_vpc.Gangadharam.id

  tags = {
    Name = "Gangadhar_security"
  }
}






resource "aws_instance" "Gangadharam" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.Gangadharam.id
  vpc_security_group_ids = [aws_security_group.Gangadharam.id]

  tags = {
    name ="custom-ec2"
  }
}