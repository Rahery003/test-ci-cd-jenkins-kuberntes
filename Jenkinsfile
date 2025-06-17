pipeline {
    agent any

    environment {
        IMAGE_TAG = "andrianasolo/react-app:${BUILD_NUMBER}"
        IMAGE_LATEST = "andrianasolo/react-app:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Rahery003/test-ci-cd-jenkins-kuberntes.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t $IMAGE_TAG .
                docker tag $IMAGE_TAG $IMAGE_LATEST
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker push $IMAGE_TAG
                    docker push $IMAGE_LATEST
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    sed "s|IMAGE_PLACEHOLDER|$IMAGE_TAG|g" deployment.yaml | kubectl apply -f -
                    '''
                }
            }
        }

        stage('Success') {
            steps {
                echo "✅ Déploiement terminé avec succès !"
                echo "📦 Image déployée : $IMAGE_TAG et mise à jour de :latest"
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
