resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "argocd-philo-guestbook.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
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
resource "kubernetes_secret" "argocd_repo_secret" {
  metadata {
    name      = "guestbook-repo-secret" 
    namespace = "argocd"                
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url = "git@github.com:philopateermansour/Guestbook-Chart.git"    
    sshPrivateKey = file("${path.module}/argocd-key")
  }
}

