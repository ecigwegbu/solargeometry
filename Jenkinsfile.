pipeline {
    agent any

    environment {
        DOCKER_PATH = '/Applications/Docker.app/Contents/Resources/bin'
        PATH = "${DOCKER_PATH}:${env.PATH}"
        DOCKER_IMAGE = "igwegbu/solargeometry:latest"
        DOCKER_CREDENTIALS_ID = "DOCKER_CREDENTIALS_ID"
        GITHUB_CREDENTIALS_ID = "GITHUB_CREDENTIALS_ID"
        EC2_SSH_CREDENTIALS_ID = "EC2_SSH_CREDENTIALS_ID"
        EC2_HOST = "18.214.151.55"
        SOLARGEOMETRY_ENV_FILE = "SOLARGEOMETRY_ENV_FILE"
        HAProxy_CONFIG_PATH = "/etc/haproxy/haproxy.cfg"
        SSL_CERT_PATH = "/etc/ssl/private/igwegbu.letsencrypt.pem"
    }

    stages {
        stage('Clone Repository') {
            steps {
                withCredentials([string(credentialsId: env.GITHUB_CREDENTIALS_ID, variable: 'GITHUB_PAT')]) {
                    sh '''
                        git clone https://${GITHUB_PAT}@github.com/ecigwegbu/solargeometry.git
                    '''
                }
            }
        }

        stage('Debug Docker Path - Pre-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which docker'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Debug Docker Path - Post-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which docker'
            }
        }

    }

}

