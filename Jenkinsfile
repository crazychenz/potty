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
    parameters {
        string(name: 'GODOT_ENGINE_PATH',
            defaultValue: 'C:\\projects\\stable\\engine\\Godot_v3.2.1-stable_win64.exe',
            description: 'Godot Engine Path')
        string(name: 'GODOT_ENGINE_HUSH_ARGS',
            defaultValue: '--no-window --windowed --resolution 1x1 --position 0,0',
            description: 'Godot Arguments To Hush The GUI Noise')
        string(name: 'POTTYTIME_REPO',
            defaultValue: 'C:\\projects\\stable\\potty',
            description: 'PottyTime Git Repository Path/Url')
        string(name: 'POTTYTIME_BRANCH',
            defaultValue: '*/master',
            description: 'PottyTime Repository Branch')
        booleanParam(name: 'EXPORT_ANDROID',
            defaultValue: true,
            description: 'Export Android')
        booleanParam(name: 'EXPORT_WINDOWSDESKTOP',
            defaultValue: true,
            description: 'Export Windows Desktop')
        booleanParam(name: 'TEST_WINDOWSDESKTOP',
            defaultValue: true,
            description: 'Test Windows Desktop')
        booleanParam(name: 'TEST_ANDROID',
            defaultValue: true,
            description: 'Test Android')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: params.POTTYTIME_BRANCH]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: params.POTTYTIME_REPO]]])
            }
        }
        stage('Export-Android') {
            when { expression { params.EXPORT_ANDROID == true } }
            steps {
                bat label: 'Godot Export',
                    script: params.GODOT_ENGINE_PATH + ' ' + 
                    '--path "' + env.WORKSPACE + '\\godot" ' + 
                    '--export-debug Android "%WORKSPACE%\\PottyTime-Android.apk" ' + 
                    params.GODOT_ENGINE_HUSH_ARGS
            }
        }
        stage('Export-WindowsDesktop') {
            when { expression { params.EXPORT_WINDOWSDESKTOP == true } }
            steps {
                bat label: 'GUT', 
                    script: params.GODOT_ENGINE_PATH + ' ' + 
                    '--path "' + env.WORKSPACE + '\\godot" ' + 
                    '--export-debug WindowsDesktop ' + 
                    '"' + env.WORKSPACE + '\\PottyTime-WindowsDesktop.exe" ' + 
                    params.GODOT_ENGINE_HUSH_ARGS
                
            }
        }
        stage('Test-WindowsDesktop') {
            when { expression { params.TEST_WINDOWSDESKTOP == true } }
            steps {
                bat label: 'GUT', 
                    script: params.GODOT_ENGINE_PATH + ' ' +
                        '--no-window ' + 
                        '--path "' + env.WORKSPACE + '\\godot" ' +
                        '-s addons/gutlite/gutlite_cli.gd ' +
                        '-gtest=res://test/unit/test_simple.gd -gexit '
            }
        }
        stage('Test-Android') {
            when { expression { params.TEST_ANDROID == true } }
            steps {
                bat label: 'GUT',
                    script: 'bash /mnt/c/projects/stable/potty/run.sh'
            }
        }
    }
    post {
        always {
            // Note: Full path doesn't work.
            archiveArtifacts artifacts: "PottyTime-*.*", fingerprint: true
        }
    }
}
