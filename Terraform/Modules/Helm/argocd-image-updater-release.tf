resource "helm_release" "argocd_image_updater" {
  name       = "argocd-image-updater"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "0.12.2"
  chart      = "argocd-image-updater"
  values     = [file("${path.module}/Values/image-updater-values.yml")]
  depends_on = [helm_release.argocd]
}
