resource "kubernetes_service_account" "argocd_image_updater_sa" {
  metadata {
    name      = "argocd-image-updater-sa"
    namespace = "argocd"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.image_updater_role
    }
  }
}