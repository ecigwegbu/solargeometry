pipeline {
    agent any

    environment {
        DOCKER_PATH = '/Applications/Docker.app/Contents/Resources/bin'
        PATH = "${DOCKER_PATH}:${env.PATH}"
        DOCKER_IMAGE = "igwegbu/solargeometry:latest"
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

        stage('Debug Docker Path - Pre-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which docker'
		sh 'pwd'
		sh 'whoami'
		
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

