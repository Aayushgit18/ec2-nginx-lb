output "app_ips" {
  value = aws_instance.app[*].public_ip
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

