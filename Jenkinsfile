pipeline {
    agent any

    environment {
        IMAGE = "andrianasolo/react-app:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Rahery003/test-ci-cd-jenkins-kuberntes.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker push $IMAGE
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                sed -i 's|IMAGE_PLACEHOLDER|$IMAGE|g' deployment.yaml
                kubectl apply -f k8s/deployment.yaml
                """
            }
        }


        stage('Success') {
            steps {
                echo "✅ Déploiement terminé avec succès ! Image déployée : $IMAGE"
            }
        }
    }

    post {
        failure {
            echo "❌ Échec du pipeline."
        }
        success {
            echo "🎉 Pipeline terminé avec succès."
        }
    }
}

