FROM jenkins/jenkins:latest-jdk17

USER root

ENV ADMIN_USER=admin \
    ADMIN_PASSWORD=password

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/

#Install gcc
RUN apt-get -qq update && \
    apt-get upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y libz-dev | sh

# Install jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

#Install graalvm
RUN curl -LO https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.1/graalvm-ce-java17-linux-amd64-22.3.1.tar.gz && \
    tar xzf graalvm-ce-java17-linux-amd64-22.3.1.tar.gz && \
    mv graalvm-ce-java17-22.3.1 /opt/graalvm-ce-java17-22.3.1 && \
    rm -f graalvm-ce-java17-linux-amd64-22.3.1.tar.gz | sh
ENV PATH=/opt/graalvm-ce-java17-22.3.1/bin:$PATH
ENV JAVA_HOME=/opt/graalvm-ce-java17-22.3.1

# Install Docker
RUN apt-get -qq update && \
    apt-get -qq -y install curl && \
    curl -sSL https://get.docker.com/ | sh

# Install Maven
RUN curl -LO https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz && \
    tar xzf apache-maven-3.9.0-bin.tar.gz && \
    mv apache-maven-3.9.0 /opt/apache-maven-3.9.0 && \
    rm -f apache-maven-3.9.0-bin.tar.gz | sh
ENV PATH=/opt/apache-maven-3.9.0/bin:$PATH
ENV _JAVA_OPTIONS=-Djdk.net.URLClassPath.disableClassPathURLCheck=true

# Install kubectl and helm
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
    






