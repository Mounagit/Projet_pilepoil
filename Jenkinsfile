// Lancement des jobs sur la machine slave_jenkins
node('slave_jenkins') {

    // On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    docker.image('mounabal/projetdevops:latest').inside() {
        // On récupère le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
        //    sh "mv ./terraform_appli/* ."
        }
               
        // On initialise, on planifie, on applique, après bien des aventures
        stage('Terraform Init, Plan & Apply'){
            withCredentials([file(credentialsId: 'backend', variable: 'LouBega')]) {
                // On initialise
                sh """
                cd terraform_appli
                terraform init
                terraform plan -var-file=main.tfvars -var-file=$LouBega -out=terraplante
                terraform apply terraplante
                """
            }
        }

        // Récupération du projet corrigé sur notre git
        stage('Clone du git du projet'){       
            git url: 'https://github.com/Mounagit/Code_Source.git'
        } 
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
        withCredentials([sshUserPrivateKey(credentialsId: 'MounaSylvain', keyFileVariable: 'key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i $key -o StrictHostKeyChecking=no target/restfulweb-1.0.0-SNAPSHOT.jar ${MounaSylvain}@mounasylvain.francecentral.cloudapp.azure.com:/home/MounaSylvain"
        }  
    }

    // On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    docker.image('mounabal/projetdevops:latest').inside() {
        // On récupère le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
        }
 
        withCredentials([sshUserPrivateKey(credentialsId: 'MounaSylvain', keyFileVariable: 'key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "ls -la ~/"
            sh "ls -la ~/home/${MounaSylvain}"
            sh "mkdir /home/${MounaSylvain}/.ssh"
            sh "cat $key > /home/${MounaSylvain}/.ssh/klee"
            sh "chmod 400  /home/${MounaSylvain}/.ssh/klee"
        }
        
      // On gère ensuite la partie Ansible
        stage('Deploiement Ansible') {
            ansiblePlaybook (
                colorized: true, 
                become: true,
                playbook: 'ansible/playbook.yml',
                inventory: 'ansible/inventory.ini',
                hostKeyChecking: false,
                credentialsId: 'MounaSylvain'
            )
         }
    } 
}
