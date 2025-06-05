  pipeline {
    agent {
      kubernetes {
        yaml """
  apiVersion: v1
  kind: Pod
  metadata:
    labels:
      some-label: kaniko
  spec:
    serviceAccountName: kaniko-sa
    containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      command: 
      - busybox/cat
    restartPolicy: Never
  """
      }
    }

    environment {
      FRONTEND_IMAGE = "355294402015.dkr.ecr.us-east-1.amazonaws.com/front-repo"
      BACKEND_IMAGE = "355294402015.dkr.ecr.us-east-1.amazonaws.com/back-repo"
      TAG = "v1.${env.BUILD_NUMBER}"
      FRONTEND_CONTEXT = "frontend"
      BACKEND_CONTEXT = "backend"
      DOCKERFILE = "Dockerfile"
    }

    stages {
      stage('Clone Repo') {
        steps {
          git branch: 'main', url: 'https://github.com/philopateermansour/guestbook.git'
        }
      }

      stage('Build and Push frontend image') {
        steps {
          container('kaniko') {
            sh """
            /kaniko/executor \
              --context=${FRONTEND_CONTEXT} \
              --dockerfile=${DOCKERFILE} \
              --destination=${FRONTEND_IMAGE}:${TAG} \
              --verbosity=debug
            """
          }
        }
      }
      stage('Build and Push backend image') {
        steps {
          container('kaniko') {
            sh """
            /kaniko/executor \
              --context=${BACKEND_CONTEXT} \
              --dockerfile=${DOCKERFILE} \
              --destination=${BACKEND_IMAGE}:${TAG} \
              --verbosity=debug
            """
          }
        }
      }
    }
  }