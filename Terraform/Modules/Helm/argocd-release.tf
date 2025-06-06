resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "8.0.14"
  chart            = "argo-cd"
  values           = [file("${path.module}/Values/argocd-values.yml")]
}

resource "kubectl_manifest" "argocd_application" {
  provider = kubectl
  yaml_body = <<END
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app
  namespace: argocd
  annotations:
    argocd-image-updater.argoproj.io/image-list: frontend=${var.ecr_frontend_repo_url}:v1.x,backend=${var.ecr_backend_repo_url}:v1.x
    
    argocd-image-updater.argoproj.io/frontend.helm.image-name: frontend.image.repository
    argocd-image-updater.argoproj.io/frontend.helm.image-tag: frontend.image.tag
    
    argocd-image-updater.argoproj.io/backend.helm.image-name: backend.image.repository
    argocd-image-updater.argoproj.io/backend.helm.image-tag: backend.image.tag

    argocd-image-updater.argoproj.io/app.update-strategy: semver    
    argocd-image-updater.argoproj.io/write-back-method: git:secret:argocd/guestbook-repo-secret

spec:
  project: default
  source:
    repoURL: "git@github.com:philopateermansour/Guestbook-Chart.git"
    
    targetRevision: HEAD
    path: "." 

  destination:
    server: https://kubernetes.default.svc
    namespace: default
  
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true 
END
}
