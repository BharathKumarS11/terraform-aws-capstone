output "db_instance_id" {
  value = aws_db_instance.app.id
}

output "db_endpoint" {
  value = aws_db_instance.app.address
}

output "db_port" {
  value = aws_db_instance.app.port
}

output "db_name" {
  value = aws_db_instance.app.db_name
}