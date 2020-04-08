pipeline {
    agent {
        node { label 'LocalNode' }
    }
    options {
        // Only keep the last 5 builds.
        buildDiscarder(logRotator(numToKeepStr: '5'))
        // No concurrent runs of Pipeline
        disableConcurrentBuilds()
        // Total Pipeline Time Limit
        //timeout(time: 1, unit: 'HOURS')
        // Console output prepended with timestamps.
        //timestamps()
    }
    //parameters {
    //    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    //    text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
    //    booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
    //    choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
    //    password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    //}
    stages {
        //stage('Checkout') {
        //    steps {
        //        build 'PottyTime-Checkout'
        //    }
        //}
        stage('Exports') {
            parallel {
                stage('PottyTime-Export-Android') {
                    steps {
                        build 'PottyTime-Export-Android'
                    }
                }
                stage('PottyTime-Export-WindowsExe') {
                    steps {
                        build 'PottyTime-Export-WindowsExe'
                    }
                }
            }
        }
    }
}