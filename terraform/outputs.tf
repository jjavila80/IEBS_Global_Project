output "instance_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.k8s_node.public_ip
}

output "private_key_pem" {
  description = "Clave privada para conectar vía SSH"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

