resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  repository       = "https://charts.external-secrets.io/"
  version          = "0.17.1-rc1"
  chart            = "external-secrets"
  values           = [file("${path.module}/Values/external-secrets-values.yml")]
}

resource "kubectl_manifest" "cluster_secret_store" {
  
  yaml_body = <<-END
    apiVersion: external-secrets.io/v1
    kind: ClusterSecretStore
    metadata:
      name: aws-secrets-manager-store
    spec:
      provider:
        aws:
          service: SecretsManager
          region: "us-east-1"
          auth:
            serviceAccount:
              name: external-secrets-sa 
              namespace: external-secrets          
  END
}