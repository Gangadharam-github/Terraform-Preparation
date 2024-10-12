output "pblic_IP" {
  value = aws_instance.name.public_ip
  description = "calling public ip of ec2 instance"
}

output "private_id" {
  value = aws_instance.name.private_ip
  description = "calling private ip for ec2 instance"
  sensitive = true
}