output "public_repository_url" {
  value = module.ecr_public_repo.repository_url
}

output "private_repository_url" {
  value = module.ecr_private_repo.repository_url
}
