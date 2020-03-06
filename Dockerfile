FROM centos:7
RUN yum -y install git unzip ansible
RUN curl -s -LO https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip terraform_0.12.21_linux_amd64.zip -d /usr/local/bin/
RUN mkdir ~/.ssh/
RUN echo "Host *" >> ~/.ssh/config
RUN echo "StrictHostKeyChecking no" >> ~/.ssh/config
RUN echo "UserKnownHostsFile=/dev/null" >> ~/.ssh/config
RUN echo "IdentityFile ~/.ssh/klee" >> ~/.ssh/config
RUN echo "Host mongodbtest" >> ~/.ssh/config
RUN echo "Hostname mounasylvaintest.francecentral.cloudapp.azure.com" >> ~/.ssh/config
RUN echo "User MounaSylvain" >> ~/.ssh/config