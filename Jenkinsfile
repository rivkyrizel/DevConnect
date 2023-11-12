pipeline {
    agent any

    triggers {
        pollSCM('*/10 * * * *')
    }

    environment {
        IMAGE_NAME = 'django'
        ARTIFACT_URL = 'me-west1-docker.pkg.dev/devconnect-project/rivky-rizel-artifacts/dev_connect'
        COMMIT = 'sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()'
        CONTEINER_NAME = "django"
    }

    stages {
        stage('Debug') {
            steps {
                script {
                    sh 'ls -la ${workspace}'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${COMMIT} .'
                sh 'docker images'
                sh "docker run -d --name ${CONTEINER_NAME} -p 8000:8000 django_app:${COMMIT}"

            }
        }


        stage('Test') {
            steps {
                script {
                    sh "docker exec ${CONTEINER_NAME} python django_web_app/manage.py test"
                }
            }
        }

        stage('Push to Artifact Registry') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    // Push the image to the Artifact Registry with the commit message as the version
                    sh 'gcloud auth configure-docker me-west1-docker.pkg.dev'
                    sh 'docker tag ${IMAGE_NAME}:${COMMIT} ${ARTIFACT_URL}:${COMMIT}'
                    sh 'docker push ${ARTIFACT_URL}:${COMMIT}'

                }
            }
        }

        stage('Deploy to Production') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    // Apply the Kubernetes deployment and service manifests
                    sh """
                    gcloud container clusters get-credentials rivky-rizel-cluster --zone me-west1-b --project devconnect-project
                    kubectl apply -f kubernetes/deployment.yaml
                    kubectl apply -f kubernetes/service.yaml
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'The pipeline failed :('
        }

        // always {
        //     // Clean up resources and workspace
        //     //cleanWs()
        // }
    }
}
