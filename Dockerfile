FROM centos:7
RUN yum -y install git unzip ansible
RUN curl -s -LO https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip terraform_0.12.21_linux_amd64.zip -d /usr/local/bin/
