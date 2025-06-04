resource "aws_iam_role" "bastion_eks_access_role" {
  name = "bastion-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "bastion-access-role"
  }
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion-eks-access-profile"
  role = aws_iam_role.bastion_eks_access_role.name
}

resource "aws_iam_policy" "eks_describe_cluster" {
  name        = "CustomEKSDescribeCluster"
  description = "Allow eks:DescribeCluster on eks-cluster"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "eks:DescribeCluster",
      Resource = "arn:aws:eks:us-east-1:454953019216:cluster/eks-cluster"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_eks_describe_policy" {
  role       = aws_iam_role.bastion_eks_access_role.name
  policy_arn = aws_iam_policy.eks_describe_cluster.arn
}
