// Lancement des jobs sur le slave
node('slave_jenkins') {
    // Clone du projet corrigé sur notre git :
    stage('Clone du git du projet'){       
        git url: 'https://github.com/Mounagit/Code_Source.git'
    }
    
    stage('Build du jar avec Maven') {
        sh "mvn clean package"
    }
    
    stage('on push le jar sur le serveur') {
        withCredentials([sshUserPrivateKey(credentialsId: 'slave_jenkins', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i \$key target/restfulweb-1.0.0-SNAPSHOT.jar MounaSylvain@52.143.140.100:/home/MounaSylvain"
        }
    }

}


