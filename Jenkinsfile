
pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'sharmilan6'
        APP_NAME = 'devops-build'
        EC2_HOST = '54.198.95.209'
        EC2_USER = 'ubuntu'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        env.DOCKER_IMAGE =
                            "${DOCKERHUB_USERNAME}/dev:${BUILD_NUMBER}"
                    }
                    else if (env.BRANCH_NAME == 'main') {
                        env.DOCKER_IMAGE =
                            "${DOCKERHUB_USERNAME}/prod:${BUILD_NUMBER}"
                    }

                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push DEV Image') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DH_PASS" | docker login \
                        -u "$DH_USER" --password-stdin

                        docker push "$DOCKER_IMAGE"

                        docker tag "$DOCKER_IMAGE" \
                        "$DOCKERHUB_USERNAME/project1_dev:latest"

                        docker push "$DOCKERHUB_USERNAME/project1_dev:latest"

                        docker logout
                    '''
                }
            }
        }

        stage('Push PROD Image') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DH_PASS" | docker login \
                        -u "$DH_USER" --password-stdin

                        docker push "$DOCKER_IMAGE"

                        docker tag "$DOCKER_IMAGE" \
                        "$DOCKERHUB_USERNAME/project1_prod:latest"

                        docker push "$DOCKERHUB_USERNAME/project1_prod:latest"

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no \
                        $EC2_USER@$EC2_HOST "
                            docker pull \
                            $DOCKERHUB_USERNAME/prod:latest

                            docker stop devops-app || true
                            docker rm devops-app || true

                            docker run -d \
                            --name devops-app \
                            --restart unless-stopped \
                            -p 80:80 \
                            $DOCKERHUB_USERNAME/prod:latest
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check Jenkins console output.'
        }
    }
}
