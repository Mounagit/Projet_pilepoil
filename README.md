###########################################################
###                   Projet Mambo No. 5                ###
###                    Pourquoi ce nom ?                ###
### Parce qu'il s'agit du 5ème Projet du groupe Mambo ! ###
###########################################################

Ce projet traite du déploiement d'une plateforme d'intégration continue (PIC) tout en intégrant des outils de CI/CD. Le but est de développer une pile complète de déploiement continue permettant de livrer sur différents environnements techniques de l’entreprise : test et production.
Toute l'infrastructure sera créée avec des ressources sur le Cloud Azure.
La PIC est constituée d’une machine Master, où Jenkins, Git et Java seront installés, et d’une machine Slave rattachée à la machine Master par une connexion ssh, où Java8, Java12, Git, Terraform, Maven, Ansible et Docker seront installés.
La pile complète est constituée de Serveurs Test et Prod ainsi que de deux bases de données (BDD), MongoDB.

Pré-requis :
Installer VirtualBox et Vagrant sur votre poste de travail.
La machine virtuelle est configurée à partir d'un Vagrantfile.
Pour ce faire, lancer les commandes "vagrant up" et “vagrant ssh” afin de créer et de se connecter à la machine.
Installations requises : Java8, Git, Terraform/Azure-cli, Ansible.
L’infrastructure étant choisi avec des ressources sur le Cloud Azure, il faut donc se créer un compte Azur Microsoft.
Créer un Repository Github qui permettra de stocker tous les fichiers de configuration/installation : scripts terraform, le dockerfile pour le build d’image, le jenkinsfile, le Vagrantfile ainsi que les rôles ansible qui permettront le provisionning des VM.
Lien du repo : https://github.com/Mounagit/Projet_pilepoil.git
Créer un Repository DockerHub pour y stocker les images terraform et ansible.
Lien du repo : h3tr4d/projetdevops


Installation :
Description de la Plateforme d’Intégration Continue

Configuration de la connexion ssh.
Une paire de clé ssh est générée sur la machine Vagrant afin d'établir une connexion entre les différentes VM qui seront créées.
Création de script terraform
Des scripts terraform sont créés afin de créer toute l’infrastructure. Les machines de la PIC ( Master et Slave) sont créées à partir du même ressource groupe dans un même Virtual Network (Vnet), et dans des subnets bien distincts. 


Création de rôles ansible :
Tous les rôles sont stockés dans le dossier ansible de ce repo github. Les playbooks sont lancés depuis la machine Vagrant afin d’approvisionner les VM de la PIC et de la pile complète. La commande est la suivante : “ansible-playbook playbook.yml -i inventory”.

Description de la pile complète :
Les machines de la pile complète sont créées à partir d’un même ressource groupe, dans un même Vnet et dans deux subnets distincts englobant chacun le serveur et sa base de données.  Les machines de la pile complète sont également provisionnées par des rôles ansible.

Job pipeline: 
Un Job pipeline a été effectué sur la Master Jenkins et buildé sur le Slave.
Cette pipeline effectue les tâches suivantes :
- dockerisation de l’image terraform stockée sur Dockerhub
- clone du dépôt git https://github.com/Mounagit/Projet_pilepoil.git contenant les fichiers terraform essentiels à la création de VMcommandes shell permettant de créer les VM 
- récupération du code de l’application
- build du code source avec maven 
- lancement des tests Junit
- déploiement du .jar dans le serveur test
- dockerisation de l’image terraform stockée sur Dockerhub
- clone du dépôt git https://github.com/Mounagit/Projet_pilepoil.git contenant les fichiers ansible essentiels au lancement des rôles Java12 et Mongo.db
- Récupération de la clé SSH pour la connexion au rôle Ansible
- Déploiement Ansible sur le serveur correspondant

Démarrage :
Connexion au serveur test : mounasylvaintest.francentral.cloudapp.azure.com/


Fabriqué avec :
Git/Github: Dépôt distant
DockerHub: Bibliothèque d'images
Ansible: Gestionnaire de configurations
Docker: Outil permettant de créer des conteneurs
Jenkins: Orchestrateur d'outils
Maven : Gestionnaire des dépendances/Build
Visual Studio Code: Editeur de code
Vagrant : Création et la configuration des environnements de développement virtuel
Microsoft Azure Cloud : Service de cloud computing 


Versions :
Java version 8 et 12
Maven 3.6.3
Terraform : 11.11 et 12.21
Ansible : 2.9.5
Docker: 19.03.7


Auteurs :
Sylvain ROUMIEUX alias @H4tr3dis   
Mouna BALGHADDAR alias @Mounagit
