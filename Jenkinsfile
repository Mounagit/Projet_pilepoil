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

 /*   stage('') {
        withCredentials([sshUserPrivateKey(credentialsId: 'slave_jenkins', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i \$key target/restfulweb-1.0.0-SNAPSHOT.jar MounaSylvain@52.143.140.140:/home/MounaSylvain"
        }
    } */

    /* On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    Pour résumer, notre chef d'ochestre donne l'ordre à son assistant d'aller dans l'atelier,
    et de bricoler avec les outils qu'il lui a mis à disposition */
    docker.image('mounabal/terraform_12.21:terraform').inside() {
        //on recupere le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
            sh "cd terraform_appli"
        }
        
    /*    stage('Copie Terraform Test'){
            sh "cd terraform_appli"
        }*/
        
        stage('Terraform Init, Plan & Apply'){
                //On init 
                withCredentials([file(credentialsId: 'backend', variable: 'test')]) {
                sh "terraform -version"
                sh "terraform init"
                //sh "terraform plan -var 'env=toto' -var-file=\$test -out terraplante"
                sh 'terraform plan -out=toto -var-file=main.tfvars -var-file=$test'
                sh "terraform apply terraplante"
            }
        }
   
   /*     stage(''){
            sh "terraform apply terraplante"
        }*/
    }


 /*   // On utilise l'image Ansible que l'on a stocké sur le Dockerhub correspondant        
    docker.image('mounabal/ansible_2.9.3:ansible').inside() {
        //on recupere le git qui porte nos fichiers Ansible    
        stage('git des fichiers Terraform dans une image Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
        }
        
        // Utilisation d'Ansible 
        stage('Deploiement Ansible') {
                ansiblePlaybook (
                    colorized: true, 
                    become: true,
                    playbook: 'ansible/playbook-prod.yml',
                    inventory: 'ansible/inventory.ini',
                    hostKeyChecking: false,
                    credentialsId: 'slave'
                )
        }
        
    } */

}



