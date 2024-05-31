pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
        DOCKER_IMAGE = "igwegbu/solargeometry:latest"
        DOCKER_CREDENTIALS_ID = "DOCKER_CREDENTIALS_ID"
        EC2_SSH_CREDENTIALS_ID = "EC2_SSH_CREDENTIALS_ID"
        EC2_HOST = "18.214.151.55"
        SOLARGEOMETRY_ENV_FILE = "/home/ubuntu/SOLARGEOMETRY_ENV_FILE"
        HAProxy_CONFIG_PATH = "/etc/haproxy/haproxy.cfg"
        SSL_CERT_PATH = "/etc/ssl/private/igwegbu.letsencrypt.pem"
    }

    stages {
        stage('Prepare Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                sh 'git clone https://github.com/ecigwegbu/solargeometry.git'
            }
        }

        stage('Build Podman Image') {
            steps {
                sh 'podman build -t ${DOCKER_IMAGE} -f solargeometry/Dockerfile solargeometry'
            }
        }

        stage('Test Podman Image') {
            steps {
                script {
                    sh 'podman run --net=host --rm ${DOCKER_IMAGE} echo "Image test successful"'
                }
            }
        }

        stage('Push Podman Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DOCKER_CREDENTIALS_ID', variable: 'DOCKER_PAT')]) {
                        sh 'podman login --username igwegbu --password ${DOCKER_PAT} docker.io'
                        sh 'podman push ${DOCKER_IMAGE} docker://igwegbu/solargeometry:latest --log-level debug'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.EC2_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} << 'EOF'
                    podman pull docker.io/${DOCKER_IMAGE}
                    podman ps -aq | xargs -r podman rm -f  # Ensure it only runs if there are containers
                    podman run -d -p 5005:5004 --env-file=${SOLARGEOMETRY_ENV_FILE} docker.io/${DOCKER_IMAGE}
                    exit 0  # Explicitly exit to avoid any EOF errors
                    'EOF'
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            script {
                try {
                    emailext(
                        subject: "Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                        body: "Build succeeded! Please check the details at ${env.BUILD_URL}",
                        to: "igwegbu@gmail.com"
                    )
                } catch (Exception e) {
                    echo "Failed to send success email: ${e.message}"
                }
            }
        }
        failure {
            script {
                try {
                    emailext(
                        subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                        body: "Please check the build log at ${env.BUILD_URL}",
                        to: "igwegbu@gmail.com"
                    )
                } catch (Exception e) {
                    echo "Failed to send failure email: ${e.message}"
                }
            }
        }
    }
}

