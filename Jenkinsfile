pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'java-17'
    }

    environment {
        IMAGE_NAME = "kunu12345/DevSecOps-AI-Powered:${GIT_COMMIT}"
    }

    stages {

        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/Krunal-Dharme/DevSecOps-AI-Powered.git',
                    branch: 'main'
            }
        }

        stage('Compile') {
            steps {
                sh '''
                    echo "Compiling the code..."
                    mvn compile
                '''
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Building the application..."
                    mvn package
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    printenv
                    docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )
                    ]) {
                        sh '''
                            echo "Logging into Docker Hub..."
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        '''
                    }
                }
            }
        }

        stage('Docker Push') {
            steps {
                sh '''
                    echo "Pushing Docker image..."
                    docker push ${IMAGE_NAME}
                '''
            }
        }

        stage('Update Kubeconfig') {
            steps {
                sh '''
                    echo "Updating kubeconfig..."
                    aws eks update-kubeconfig \
                        --region centralindia \
                        --name quantam-cluster
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(
                    clusterName: 'quantam-aks',
                    credentialsId: 'kube',
                    namespace: 'quantam',
                    serverUrl: 'https://quantamaks-c4eef10z.hcp.centralindia.azmk8s.io',
                    restrictKubeConfigAccess: false
                ) {
                    sh '''
                        echo "Deploying to Kubernetes..."
                        kubectl apply -f deployment.yaml -n quantam
                    '''
                }
            }
        }
    }
}
