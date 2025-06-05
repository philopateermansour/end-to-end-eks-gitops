resource "aws_iam_role" "kaniko_ecr_push" {
  name = "KanikoECRPushRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_url, "https://", "")}:sub" = "system:serviceaccount:jenkins:kaniko-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "kaniko_ecr_push_policy" {
  name = "KanikoECRPushPolicy"
  role = aws_iam_role.kaniko_ecr_push.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })
}