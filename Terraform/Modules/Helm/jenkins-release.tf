resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "jenkins"
  repository = "https://charts.jenkins.io/"
  version    = "5.8.55"
  chart      = "jenkins"
  values     = [file("${path.module}/Values/jenkins-values.yml")]
}
