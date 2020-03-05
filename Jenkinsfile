// Lancement des jobs sur la machine slave_jenkins
node('slave_jenkins') {

    // On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    docker.image('mounabal/my_terraform:latest').inside() {
        // On récupère le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
            sh "mv ./terraform_appli/* ."
        }
               
        // 
        stage('Terraform Init, Plan & Apply'){
            withCredentials([file(credentialsId: 'backend', variable: 'LouBega')]) {
                // On initialise
                sh 'terraform init'
                sh 'terraform plan -var-file=main.tfvars -var-file=$LouBega -out=terraplante'
                sh 'terraform apply -auto-approve terraplante'
            }
        }

        // Récupération du projet corrigé sur notre git
        stage('Clone du git du projet'){       
            git url: 'https://github.com/Mounagit/Code_Source.git'
        }
        
        // Construction du jar avec Maven
        stage('Build jar code source') {
            sh "mvn clean package"
        }
        
        stage('On lance les tests Junit sur le jar') {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
        }
        
        stage('On récupère le tout en le poussant sur notre serveur') {
            withCredentials([sshUserPrivateKey(credentialsId: 'slave_jenkins', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
                sh "scp -i \$key -o StrictHostKeyChecking=no target/restfulweb-1.0.0-SNAPSHOT.jar MounaSylvain@mounasylvain.francecentral.cloudapp.azure.com:/home/MounaSylvain"
            }  
        }
    
        // On passe à la partie Ansible
   /*     stage('Deploiement Ansible') {
                ansiblePlaybook (
                    colorized: true, 
                    become: true,
                    playbook: 'ansible/playbook-prod.yml',
                    inventory: 'ansible/inventory.ini',
                    hostKeyChecking: false,
                    credentialsId: 'slave'
                )
        }*/

    }

}



