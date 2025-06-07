resource "helm_release" "prometheus_stack" {
  name             = "prometheus-stack"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "72.9.1"
  chart            = "kube-prometheus-stack"
  values           = [file("${path.module}/Values/prometheus_stack-values.yml")]
  timeout          = 600
}

