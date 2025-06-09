resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  namespace        = "nginx-ingress"
  create_namespace = true
  repository       = "https://helm.nginx.com/stable"
  version          = "2.1.0"
  chart            = "nginx-ingress"
}