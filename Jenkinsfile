pipeline {
  agent any
  stages {
    stage('Lint') {
      steps {
        node(label: 'ruby') {
          sh 'rubocop'
        }
        
      }
    }
  }
}