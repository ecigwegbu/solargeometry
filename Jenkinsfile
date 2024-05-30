pipeline {
    agent any

    environment {
        PODMAN_PATH = '/usr/local/bin'
        PATH = "${PODMAN_PATH}:${env.PATH}"
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

        stage('Build Podman Image') {
            steps {
                sh 'podman build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Debug Podman Path - Post-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which podman'
                sh 'podman --version'
            }
        }
    }
}

