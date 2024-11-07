output "web_instance_private_ip" {
  value = aws_instance.web_instance.private_ip
}

output "web_instance_public_ip" {
  value = aws_instance.web_instance.public_ip
}

output "db_instance_private_ip" {
  value = aws_instance.db_instance.private_ip
}

output "web_instance_dns" {
  value = aws_instance.web_instance.public_dns
}

