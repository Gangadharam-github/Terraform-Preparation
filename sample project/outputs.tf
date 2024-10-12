output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.web.public_ip
}

output "bucket_name" {
  description = "S3 Bucket name"
  value       = aws_s3_bucket.remote
}

output "db_endpoint" {
  description = "RDS DB endpoint"
  value       = aws_db_instance.mydb.endpoint
}