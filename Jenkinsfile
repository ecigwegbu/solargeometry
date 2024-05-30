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
        	sh '/usr/local/bin/docker build -t igwegbu/solargeometry:latest .'
    	    }
        }

	stage('Debug Docker Path - Post-Build') {
    		steps {
        		sh 'echo $PATH'
        		sh 'which docker'
    		}
	}

        stage('Test Docker Image') {
            steps {
                script {
                    docker.image(env.DOCKER_IMAGE).inside {
                        sh '''
                            if ls tests/*.py 1> /dev/null 2>&1; then
                                pytest
                            else
                                echo "No tests found, skipping pytest."
                            fi
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS_ID) {
                        docker.image(env.DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                sshagent([env.EC2_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} << EOF
                    sudo docker pull ${DOCKER_IMAGE}
                    sudo docker rm -f \$(sudo docker ps -aq)
                    sudo docker run -d -p 5005:5004 --env-file=${SOLARGEOMETRY_ENV_FILE} ${DOCKER_IMAGE}
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

