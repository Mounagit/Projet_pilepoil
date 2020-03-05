// Lancement des jobs sur le slave
node('slave_jenkins') {
    // Clone du projet corrigé sur notre git :
    stage('Clone du git du projet'){       
        git url: 'https://github.com/Mounagit/Code_Source.git'
    }
    
    stage('Build du jar avec Maven') {
        sh "mvn -version"
        sh "mvn clean package"
    }
    
    // PENSER A CHANGER L'IP DU MASTER POUR UNE URL !!!
    stage('on push le jar sur le serveur') {
        withCredentials([sshUserPrivateKey(credentialsId: 'slave_jenkins', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i \$key target/restfulweb-1.0.0-SNAPSHOT.jar MounaSylvain@52.143.140.100:/home/MounaSylvain"
        }
    }
    
    //On utilise l'image Terraform que l'on a strocké sur notre Dockerhub
    docker.image('mounabal/terraform_12.21').inside() {
    
        //on recupere le git pour avoir nos fichiers Terraform    
        stage('git des fichiers Terraform dans une image Docker') {
            git url: 'https://github.com/Mounagit/MamboNo5/terraform_appli.git'
        }
        
                stage('on copie les fichiers terraform dans le repertoire de travail'){
            sh "mv ./terraform/* ."
        }
        
        stage('Terraform init'){
                //on passe les fichiers de credential
                withCredentials([file(credentialsId: 'backend.tfvars', variable: 'test')]) {
                sh "terraform init"
                sh "terraform plan -var 'env=toto' -var-file=\$test -out planfile"
            }
        }
        
    }
}




