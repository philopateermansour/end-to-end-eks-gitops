resource "aws_secretsmanager_secret" "grafana" {
  name = "grafana/credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id     = aws_secretsmanager_secret.grafana.id
  secret_string = jsonencode({
    admin-user     = var.grafana_admin_user
    admin-password = var.grafana_admin_password
  })
}
data "aws_secretsmanager_secret_version" "grafana" {
  secret_id = aws_secretsmanager_secret.grafana.id
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "grafana_auth" {
  metadata {
    name      = "grafana-auth"
    namespace = "monitoring"
  }

  data = {
    "admin-user"     = jsondecode(data.aws_secretsmanager_secret_version.grafana.secret_string)["admin-user"]
    "admin-password" = jsondecode(data.aws_secretsmanager_secret_version.grafana.secret_string)["admin-password"]
  }
  type = "Opaque"
  depends_on = [ kubernetes_namespace.monitoring ]
}
resource "kubernetes_ingress_v1" "prometheus_ingress" {
  metadata {
    name      = "prometheus-ingress"
    namespace = "monitoring"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "prometheus-philo-guestbook.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-stack-kube-prom-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "grafana-philo-guestbook.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}