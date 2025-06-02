resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = var.cluster_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd6c7e2"]
}