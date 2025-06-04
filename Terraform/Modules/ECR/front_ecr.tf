resource "aws_ecr_repository" "front_ecr" {
  name                 = var.front_ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete = true
  
  image_scanning_configuration {
    scan_on_push = true
  }
}
