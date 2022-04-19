pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/andynze/java-project.git'
            }
        }   
        stage('Install') {
            steps {
                sh 'cd MyWebApp && mvn clean package'
            }
        } 
        stage('Test') {
            steps {
                sh 'cd MyWebApp && mvn test'
            }
        }
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-cred', path: '', url: 'http://3.235.0.243:8080/')], contextPath: 'path', war: '**/*.war'
            }
        }
    }
}

