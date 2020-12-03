output "public_dns" {
  value       = [
    "Frontend: ${aws_instance.frontend.public_dns}",
    "Backend: ${aws_instance.backend.public_dns}"
  ]
}