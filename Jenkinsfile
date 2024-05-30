pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
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

        stage('Check Directory Contents') {
            steps {
                sh 'ls -l'
                sh 'ls -l solargeometry'
            }
        }

        stage('Build Podman Image') {
            steps {
                // Assuming Dockerfile is in the solargeometry directory
                sh 'podman build -t ${DOCKER_IMAGE} -f solargeometry/Dockerfile solargeometry'
            }
        }

        stage('Debug Podman Path - Post-Build') {
            steps {
                sh 'echo $PATH'
                sh 'which podman'
            }
        }
    }
}

