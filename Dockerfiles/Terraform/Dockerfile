FROM centos:8

ENV JAVA_VERSION 1.8.0

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel && \
  yum clean all

RUN yum install -y git

RUN curl -fsSL https://github.com/hashicorp/terraform/archive/v0.12.21.tar.gz | tar xzf - -C /usr/local/bin && \
  yum rm terraform_0.12.21_linux_amd64.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java
ENV TERRAFORM_HOME /usr/local/bin