# Guestbook Application Deployment with Terraform, Helm, Jenkins, and ArgoCD

This project provides an infrastructure-as-code (IaC) solution for deploying the Guestbook application on AWS using Terraform and Helm. It includes modules for networking, security, compute, EKS, and monitoring, as well as Helm charts for deploying the application and its dependencies. Additionally, a Jenkins pipeline is configured to build and push Docker images using Kaniko, and ArgoCD is used for GitOps-based application deployment.

## Project Structure

### Terraform
- **Modules**: Contains reusable Terraform modules for various infrastructure components.
  - `Network`: VPC, subnets, route tables, NAT gateway, and internet gateway.
  - `Security`: Security groups, IAM roles, and external secrets.
  - `Compute`: Bastion host and cluster access.
  - `ECR`: Frontend and backend ECR repositories.
  - `EKS`: EKS cluster and node groups.
  - `Helm`: Helm releases for deploying Kubernetes resources.
  - `kubernetes`: Kubernetes manifests for additional configurations.

- **Main Files**:
  - `main.tf`: Main Terraform configuration file.
  - `variables.tf`: Input variables for the Terraform configuration.
  - `backend.tf`: Backend configuration for Terraform state.

### External Secrets
- **Helm Chart**: Deploys the External Secrets operator to manage secrets in Kubernetes.
- **AWS Secrets Manager**: Secrets are managed using and integrated with Kubernetes via the External Secrets operator.
- **ClusterSecretStore**: Configures AWS Secrets Manager as the secret store for the cluster.

### Guestbook Helm Chart
- **Chart.yaml**: Defines the Helm chart metadata.
- **values.yaml**: Configurable values for the Helm chart.
- **templates/**: Kubernetes manifests for deploying the Guestbook application.

### Jenkinsfile
The Jenkins pipeline is configured to automate the building and pushing of Docker images for the frontend and backend applications. It uses **Kaniko**, a tool designed for building container images in Kubernetes without requiring Docker-in-Docker (DinD). Kaniko runs as a container in a Kubernetes pod and securely builds images by reading the Dockerfile and context directly from the filesystem.

The pipeline includes the following stages:
1. **Clone Repo**: Clones the Guestbook application repository from GitHub.
2. **Build and Push Frontend Image**: Uses Kaniko to build and push the Docker image for the frontend application to an Amazon ECR repository.
3. **Build and Push Backend Image**: Uses Kaniko to build and push the Docker image for the backend application to an Amazon ECR repository.

The Kaniko executor is run in a Kubernetes pod with a service account (`kaniko-sa`) that has the necessary permissions to push images to ECR.

### ArgoCD
ArgoCD is used to implement GitOps for the Guestbook application. It continuously monitors the Git repository for changes and ensures that the Kubernetes cluster state matches the desired state defined in the repository. ArgoCD simplifies application deployment and management by automating the synchronization process.

### ArgoCD Image Updater
ArgoCD Image Updater is configured to automatically update application images in the Git repository when new versions are pushed to the container registry. This ensures that the latest application versions are deployed without manual intervention.

## Features
- **Networking**: Configures a VPC with public and private subnets, NAT gateway, and internet gateway.
- **Security**: Sets up security groups, IAM roles, and external secrets integration with AWS Secrets Manager.
- **Compute**: Deploys a bastion host for secure access to the cluster.
- **EKS**: Provisions an EKS cluster with managed node groups.
- **Monitoring**: Deploys Prometheus, Grafana, and Alertmanager for monitoring.
- **Helm**: Manages application deployment using Helm charts.
- **CI/CD**: Automates Docker image builds and pushes using Jenkins and Kaniko.
- **GitOps**: Automates application deployment and synchronization using ArgoCD.

## Deployment Steps

### Prerequisites
1. Install Terraform, Helm, AWS CLI, and ArgoCD CLI.
2. Configure AWS credentials and set up an S3 bucket for Terraform state.

### Terraform Deployment
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the infrastructure:
   ```bash
   terraform plan
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

### Helm Deployment
1. Update the `values.yaml` file with your configuration.
2. Deploy the Guestbook application:
   ```bash
   helm install guestbook ./guestbook
   ```

### CI/CD Pipeline
1. Configure Jenkins with the provided `Jenkinsfile`.
2. Trigger the pipeline to build and push Docker images.

### ArgoCD Deployment
1. Install ArgoCD in the Kubernetes cluster:
   ```bash
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```
2. Access the ArgoCD UI and configure the Git repository for the Guestbook application.
3. Synchronize the application to deploy it to the cluster.

### Kaniko in Jenkins
Kaniko is used in the Jenkins pipeline to securely build and push Docker images without requiring privileged access or Docker-in-Docker. The pipeline runs Kaniko in a Kubernetes pod, which is defined in the `Jenkinsfile` using a YAML configuration. The pod includes the Kaniko executor container, which reads the Dockerfile and context to build the image and pushes it to Amazon ECR. This approach ensures a secure and efficient CI/CD process for containerized applications.

## Monitoring
- Access Prometheus and Grafana using the configured ingress URLs:
  - Prometheus: `http://prometheus-philo-guestbook.com`
  - Grafana: `http://grafana-philo-guestbook.com`