output "web_server_ip" {
  value = aws_instance.hello_world.public_ip
}
