// Lancement des jobs sur la machine slave_jenkins
node('slave_jenkins') {

    // On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    docker.image('h3tr4d/projetdevops:latest').inside() {
        // On récupère le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
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
    stage('on clean avec maven') {
        sh "mvn clean"
    }
    
    // On fait les tests en parallel comme demander dans le cahier des charges
    parallel('test1': {     
        stage('on build avec maven le jar') {
            sh "mvn test"
        }
    },
    'test2': {
        stage('on build avec maven le jar') {
            sh "mvn test"
        }
    }
    )
        
    stage('on clean avec maven') {
            sh "mvn package"
    }
    
    stage('On lance les tests Junit sur le jar') {
        junit '**/target/surefire-reports/TEST-*.xml'
        archiveArtifacts 'target/*.jar'
    }
        
    stage('On récupère le tout en le poussant sur notre serveur') {
        withCredentials([sshUserPrivateKey(credentialsId: 'MounaSylvain', keyFileVariable: 'key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "scp -i \$key -o StrictHostKeyChecking=no target/restfulweb-1.0.0-SNAPSHOT.jar ${MounaSylvain}@mounasylvaintest.francecentral.cloudapp.azure.com:/home/MounaSylvain"
        }  
    }

    // On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    docker.image('h3tr4d/projetdevops:latest').inside("-v /home/stage/workspace/projet:/tmp:rw -u 0") {
        // On récupère le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Ansible dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
        }
        
        // How to Setup SSH keys for “passwordless” ssh login in Linux
        withCredentials([sshUserPrivateKey(credentialsId: 'MounaSylvain', keyFileVariable: 'key', passphraseVariable: '', usernameVariable: 'MounaSylvain')]) {
            sh "cat \$key > ~/.ssh/klee"
            sh "chmod 400  ~/.ssh/klee"
        }
        
      // On gère ensuite la partie Ansible
        stage('Deploiement Ansible') {
            ansiblePlaybook (
                colorized: true, 
                become: true,
                playbook: 'ansible/playbook_test.yml',
                inventory: 'ansible/inventory',
                hostKeyChecking: false,
                credentialsId: 'MounaSylvain'
            )
         }
    } 
}
