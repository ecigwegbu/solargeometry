pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
        DOCKER_IMAGE = "igwegbu/solargeometry:latest"
        DOCKER_CREDENTIALS_ID = "DOCKER_CREDENTIALS_ID"
        EC2_SSH_CREDENTIALS_ID = "EC2_SSH_CREDENTIALS_ID"
        EC2_HOST = "18.214.151.55"
        SOLARGEOMETRY_ENV_FILE = "SOLARGEOMETRY_ENV_FILE"
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

        stage('Debug Podman Path - Pre-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which podman'
                sh 'podman --version'
                sh 'pwd'
                sh 'whoami'
                sh 'id'
                sh 'groups'
                sh 'podman ps'
            }
        }

        stage('Check Directory Contents') {
            steps {
                sh 'ls -l'
                sh 'ls -l solargeometry'
            }
        }

        stage('Build Podman Image') {
            steps {
                sh 'podman build -t ${DOCKER_IMAGE} -f solargeometry/Dockerfile solargeometry'
            }
        }

        stage('Debug Podman Path - Post-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which podman'
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
                        retry(5) {
                            sh 'podman push ${DOCKER_IMAGE} docker://igwegbu/solargeometry:latest --log-level debug'
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.EC2_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} << EOF
                    podman pull docker.io/${DOCKER_IMAGE}
                    podman ps -aq | xargs -r podman rm -f  # Ensure it only runs if there are containers
                    podman run -d -p 5005:5004 --env-file=/home/ubuntu/SOLARGEOMETRY_ENV_FILE docker.io/${DOCKER_IMAGE}
                    EOF
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
            mail to: 'igwegbu@gmail.com',
                 subject: "Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build succeeded! Please check the details at ${env.BUILD_URL}"
        }
        failure {
            mail to: 'igwegbu@gmail.com',
                 subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Please check the build log at ${env.BUILD_URL}"
        }
    }
}

