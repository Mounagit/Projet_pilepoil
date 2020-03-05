// Lancement des jobs sur la machine slave_jenkins
node('slave_jenkins') {

    // Récupération du projet corrigé sur notre git :
    stage('Clone du git du projet'){       
        git url: 'https://github.com/Mounagit/Code_Source.git'
    }
    
    // Construction du jar avec Maven
    stage('Build jar code source') {
        sh "mvn clean package"
    }
    
    /*
    stage('') {
        withCredentials([sshUserPrivateKey(credentialsId: 'slave_jenkins', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i \$key target/restfulweb-1.0.0-SNAPSHOT.jar MounaSylvain@52.143.140.140:/home/MounaSylvain"
        }
    }
    */
    
    //On utilise l'image Terraform que l'on a stocké sur notre Dockerhub
    docker.image('mounabal/terraform_12.21').inside() {
        //on recupere le git pour avoir nos fichiers Terraform    
        stage('git des fichiers Terraform dans une image Docker') {
            git url: 'https://github.com/Mounagit/MamboNo5/terraform_appli.git'
        }
        
        stage('Copie des fichiers'){
            sh "mv ./terraform/* ."
        }
        
        stage('Terraform Init & Plan'){
                //on passe les fichiers de credential
                withCredentials([file(credentialsId: 'backend', variable: 'test')]) {
                sh "terraform init"
                sh "terraform plan -var 'env=toto' -var-file=\$test -out terraplante"
            }
        }
   
        stage(''){
            sh "terraform apply terraplante"
        }
        
    }
}




