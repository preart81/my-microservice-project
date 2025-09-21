pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      tty: true
      command:
        - cat
      volumeMounts:
        - name: workspace-volume
          mountPath: /workspace
    - name: git
      image: alpine/git:2.40.1
      tty: true
      command:
        - cat
      volumeMounts:
        - name: workspace-volume
          mountPath: /workspace
  volumes:
    - name: workspace-volume
      emptyDir: {}
'''
    }
  }
  environment {
    // ECR_REGISTRY = '804054839611.dkr.ecr.us-east-1.amazonaws.com'
    // IMAGE_NAME   = 'ecr-repo-18062025214500'
    // ECR_REGISTRY = "${output.ecr_repository_url}" // output з outputs.tf
    // IMAGE_NAME   = "${variable.repository_name}"  // variable з variables.tf
    ECR_REGISTRY = '882961642780.dkr.ecr.us-east-1.amazonaws.com'
    IMAGE_NAME   = 'ecr-repo-preart-18062025214500'
    IMAGE_TAG    = "v1.0.${BUILD_NUMBER}"
    COMMIT_EMAIL = 'jenkins@localhost'
    COMMIT_NAME  = 'jenkins'
    GIT_REPO     = 'my-microservice-project.git'
    GIT_BRANCH   = 'final-project'
    GITHUB_USER  = 'preart81'
  }
  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('git') {
          withCredentials([
          usernamePassword(
            credentialsId: 'github-token',
            usernameVariable: 'GITHUB_USER',
            passwordVariable: 'GITHUB_PAT'
          )
        ])  {
            sh '''
          git clone https://${GITHUB_USER}:${GITHUB_PAT}@github.com/${GITHUB_USER}/${GIT_REPO}
          cd my-microservice-project
          git checkout ${GIT_BRANCH} || git checkout -b ${GIT_BRANCH}
          cd django
          cp -r . /workspace/
        '''
        }
        }
        container('kaniko') {
          sh '''
        /kaniko/executor \
          --context /workspace \
          --dockerfile /workspace/Dockerfile \
          --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
          --cache=true
      '''
        }
      }
    }
    stage('Update Chart Tag in Git') {
      steps {
        container('git') {
          withCredentials([
            usernamePassword(
              credentialsId: 'github-token',
              usernameVariable: 'GITHUB_USER',
              passwordVariable: 'GITHUB_PAT'
            )
          ]) {
            sh '''
              cd my-microservice-project
              git checkout ${GIT_BRANCH}
              cd charts/django-app
              sed -i "s/tag: .*/tag: $IMAGE_TAG/" values.yaml
              git config user.email "$COMMIT_EMAIL"
              git config user.name "$COMMIT_NAME"
              git add values.yaml
              git commit -m "Update image tag to $IMAGE_TAG"
              git remote set-url origin https://${GITHUB_PAT}@github.com/${GITHUB_USER}/${GIT_REPO}
            '''
          }
        }
      }
    }
  }
}
