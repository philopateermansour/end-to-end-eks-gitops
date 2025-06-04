resource "aws_ecr_repository" "back_ecr" {
  name                 = var.back_ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}