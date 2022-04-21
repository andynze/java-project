pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'vproject', url: 'https://github.com/andynze/java-project.git'
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
        stage('Code Quality Scan') {
            steps {
                withSonarQubeEnv('sonar_token') {
                sh "mvn -f MyWebApp/pom.xml sonar:sonar"
                }
            }
        }
         stage('Code Quality Scan') {
            steps {
                rtServer {
                    id: "jfrog-art"
                url: "http://34.239.114.99:8082//artifactory",
                credentialsId: "jfrog-art"
                bypassProxy: true
                }
            }
        }
          stage('Deploy Artifacts') {
            steps {
                rtUpload (
                    serverId: 'jfrog'
                }
            } 
        }
//        stage("Quality gate") {
//            steps {
//                waitForQualityGate abortPipeline: true
//            }
//        }
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-cred', path: '', url: 'http://172.31.1.53:8080/')], contextPath: 'path', war: '**/*.war'
            }
        }
    }
}