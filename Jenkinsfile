pipeline {
agent any

// Use a tools block to ensure the SonarQube Scanner is on the PATH
// The name 'sonarScannerTool' must match the name configured in Jenkins
// under "Manage Jenkins" -> "Global Tool Configuration"
environment {
        
        SCANNER_HOME=tool 'sonar-scanner'
    }

stages {
    stage('Clone Repository') {
        steps {
            git branch: 'main', credentialsId: 'git-token', url: 'https://github.com/anto096/simple-python-flask-application.git'
        }
    }

    stage('Build, Test, and Analyze') {
        // This stage runs all Python-related tasks inside a single shell block
        // to ensure the virtual environment remains active.
        steps {
            script {
                echo 'Setting up Python environment, running tests, and performing SonarQube analysis...'
                // Use withCredentials for secure handling of the SonarQube token
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh """
                        # Create and activate the virtual environment
                        python3 -m venv venv
                        . venv/bin/activate

                        # Install dependencies for testing and packaging
                        pip install --upgrade pip setuptools wheel pytest pytest-cov coverage twine

                        # Install the application
                        pip install -e .

                        # Run unit tests with coverage
                        pytest --cov=simple_flask_app --cov-report xml:coverage.xml tests

                        # Run SonarQube analysis using the configured tool
                        $SCANNER_HOME/bin/sonar-scanner \\
                            -Dsonar.projectKey=simple-flask-app \\
                            -Dsonar.sources=simple_flask_app \\
                            -Dsonar.host.url=http://localhost:9000 \\
                            -Dsonar.login=$SONAR_AUTH_TOKEN \\
                            -Dsonar.python.coverage.reportPaths=coverage.xml
                    """
                }
            }
        }
    }

    stage('Build Python Package and Upload to Nexus') {
        // Use withCredentials for secure handling of Nexus credentials
        steps {
            withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'NEXUS_USR', passwordVariable: 'NEXUS_PSW')]) {
                sh """
                    # Activate virtual environment
                    . venv/bin/activate

                    # Build the Python package
                    python setup.py sdist bdist_wheel

                    # Upload to Nexus PyPI repository
                    twine upload \\
                        --repository-url http://localhost:8081/repository/simple-python-app/ \\
                        -u $NEXUS_USR \\
                        -p $NEXUS_PSW \\
                        dist/*
                """
            }
        }
    }
    
    stage('Build and Push Docker Image') {
        // Use withCredentials to securely log in to the Docker registry (e.g., Docker Hub)
        steps {
            script {
                def dockerImage = docker.build("antonydavid096/simple-python-flask-application:latest")
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USR', passwordVariable: 'DOCKER_PSW')]) {
                    docker.withRegistry('https://docker.io', 'docker-hub-creds') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
    
    stage('Deploy Docker Container') {
        steps {
            echo 'Running Docker container...'
            sh """
                docker rm -f simple-flask-app || true
                docker run -d --name simple-flask-app -p 5000:5000 antonydavid096/simple-python-flask-application:latest
            """
        }
    }
}

post {
    always {
        echo 'Cleaning up workspace...'
        sh 'rm -rf venv build dist *.egg-info coverage.xml'
    }
}

}
