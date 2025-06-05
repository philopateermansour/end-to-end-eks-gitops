resource "kubernetes_service_account" "kaniko_sa" {
  metadata {
    name      = "kaniko-sa"
    namespace = "jenkins"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.kaniko_role
    }
  }
}
resource "kubernetes_namespace" "jenkins_ns" {
  metadata {
    name = "jenkins"
  }
}
resource "kubernetes_persistent_volume" "my_pv" {
  metadata {
    name = "jenkins-persistent-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = ""
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = "vol-0890ae635890ac335"
        fs_type   = "ext4"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "my_pvc" {
  metadata {
    name      = "jenkins-persistent-pvc"
    namespace = "jenkins"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name        = kubernetes_persistent_volume.my_pv.metadata[0].name
    storage_class_name = ""
  }
  depends_on = [kubernetes_namespace.jenkins_ns,
                kubernetes_service_account.kaniko_sa]
}
resource "kubernetes_ingress_v1" "jenkins_ingress" {
  metadata {
    name      = "jenkins-ingress"
    namespace = "jenkins"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "jenkins-philo-guestbook.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "jenkins"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}