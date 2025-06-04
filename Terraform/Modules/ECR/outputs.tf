output "ecr_frontend_repo_url" {
  value = aws_ecr_repository.front_ecr.repository_url
}
output "ecr_backend_repo_url" {
  value = aws_ecr_repository.back_ecr.repository_url
}
output "registry_url" {
  value = split("/",aws_ecr_repository.front_ecr.repository_url)[0]
}   