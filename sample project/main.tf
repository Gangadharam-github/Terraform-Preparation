provider "aws" {
  region = "ap-south-1"  # Change to your desired region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gateway"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for EC2
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Update to a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "web-server"
  }
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = "example.com"  # Change to your domain
}

# Route 53 Record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.id
  name     = "www.example.com"
  type     = "A"
  ttl      = 300
  records  = [aws_instance.web.public_ip]
}

# SSL Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "www.example.com"  # Change to your domain
  validation_method = "DNS"

  tags = {
    Name = "My Certificate"
  }
}

# RDS Instance
resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t2.micro"
  username           = "admin"
  password           = "Password123!"  # Change to a secure password
  skip_final_snapshot = true

  tags = {
    Name = "mydb-instance"
  }
}

# Auto Scaling Group
resource "aws_launch_configuration" "web_config" {
  name          = "web-config"
  image_id     = "ami-0c55b159cbfafe1f0"  # Update to a valid AMI ID for your region
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier = [aws_subnet.public.id]
  launch_configuration = aws_launch_configuration.web_config.id

  tag {
    key                 = "Name"
    value               = "web-server-asg-instance"
    propagate_at_launch = true
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/aws/ec2/web-server"

  retention_in_days = 15
}

#amazn S3
resource "aws_s3_bucket" "remote" {
  bucket = "hello-thisis-hello-bucket"
  depends_on = [ aws_instance.web] # this is dependece block
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.remote.id
  versioning_configuration {     # this is or system vsersitonining
    status = "Enabled"
  }
}