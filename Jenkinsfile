// Lancement des jobs sur la machine slave_jenkins
node('slave_jenkins') {

    /* On utilise l'image Terraform que l'on a stocké sur le Dockerhub correspondant
    Pour résumer, notre chef d'ochestre donne l'ordre à son assistant d'aller dans l'atelier,
    et de bricoler avec les outils qu'il lui a mis à disposition */
    docker.image('mounabal/image_terraform:terraform').inside() {

        //on recupere le git qui contient les fichiers Terraform nécessaires au projet
        stage('Copie des fichiers Terraform dans Docker') {
            git url: 'https://github.com/Mounagit/Projet_pilepoil.git'
            sh "cd terraform_appli"
        }
               
        
        stage('Terraform Init, Plan & Apply'){
            withCredentials([file(credentialsId: 'backend', variable: 'test')]) {
                // On initialise
                sh "terraform init"
                sh 'terraform plan -auto-approve -var-file="main.tfvars" -var-file="test" -out=terraplante'
                sh "terraform apply terraplante
            }
        }

        // Récupération du projet corrigé sur notre git :
        stage('Clone du git du projet'){       
            git url: 'https://github.com/Mounagit/Code_Source.git'
        }
        
        // Construction du jar avec Maven
        stage('Build jar code source') {
            sh "mvn clean package"
        }
        
        stage('Junit') {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
        }
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



